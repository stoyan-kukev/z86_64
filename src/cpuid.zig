const std = @import("std");

pub const CpuidResult = struct {
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
};

pub fn get(leaf: u32, subleaf: u32) CpuidResult {
    var result: CpuidResult = undefined;

    result.eax = asm volatile ("cpuid"
        : [ret] "={eax}" (-> u32),
        : [leaf] "{eax}" (leaf),
          [subleaf] "{ecx}" (subleaf),
        : "{ebx}", "{ecx}", "{edx}", "memory"
    );

    result.ebx = asm volatile (""
        : [ret] "={ebx}" (-> u32),
    );
    result.ecx = asm volatile (""
        : [ret] "={ecx}" (-> u32),
    );
    result.edx = asm volatile (""
        : [ret] "={edx}" (-> u32),
    );

    return result;
}

pub fn getCpuVendor() [12]u8 {
    var result = get(0, 0);
    var vendor: [12]u8 = undefined;
    std.mem.copyForwards(u8, vendor[0..4], std.mem.asBytes(&result.ebx));
    std.mem.copyForwards(u8, vendor[4..8], std.mem.asBytes(&result.edx));
    std.mem.copyForwards(u8, vendor[8..12], std.mem.asBytes(&result.ecx));
    return vendor;
}
