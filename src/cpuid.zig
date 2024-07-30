const std = @import("std");

pub const CpuidResult = struct {
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
};

pub inline fn get(leaf: u32) CpuidResult {
    var eax: u32 = undefined;
    var ebx: u32 = undefined;
    var edx: u32 = undefined;
    var ecx: u32 = undefined;

    asm volatile (
        \\cpuid
        : [eax] "={eax}" (eax),
          [ebx] "={ebx}" (ebx),
          [edx] "={edx}" (edx),
          [ecx] "={ecx}" (ecx),
        : [leaf] "{eax}" (leaf),
    );

    return .{
        .eax = eax,
        .ebx = ebx,
        .ecx = ecx,
        .edx = edx,
    };
}

pub fn getCpuVendor() [12]u8 {
    var result = get(0);

    var vendor: [12]u8 = undefined;
    std.mem.copyForwards(u8, vendor[0..4], std.mem.asBytes(&result.ebx));
    std.mem.copyForwards(u8, vendor[4..8], std.mem.asBytes(&result.ecx));
    std.mem.copyForwards(u8, vendor[8..12], std.mem.asBytes(&result.edx));

    return vendor;
}
