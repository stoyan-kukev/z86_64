const std = @import("std");

pub const CpuidResult = struct {
    eax: u32,
    ebx: u32,
    ecx: u32,
    edx: u32,
};

pub inline fn cpuid(leaf: u32) CpuidResult {
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
    var result = cpuid(0);

    var vendor: [12]u8 = undefined;
    std.mem.copyForwards(u8, vendor[0..4], std.mem.asBytes(&result.ebx));
    std.mem.copyForwards(u8, vendor[4..8], std.mem.asBytes(&result.edx));
    std.mem.copyForwards(u8, vendor[8..12], std.mem.asBytes(&result.ecx));

    return vendor;
}

pub const CpuInfo = struct {
    var cached_result: ?CpuidResult = null;

    fn getCachedCpuid1() CpuidResult {
        return cached_result orelse {
            cached_result = cpuid(1);
        };
    }

    pub fn getLocalApicId() u8 {
        const result = getCachedCpuid1();
        return @intCast((result.ebx >> 24) & 0xFF);
    }

    pub fn getMaxLogicalProcessors() u8 {
        const result = getCachedCpuid1();
        return @intCast((result.ebx >> 16) & 0xFF);
    }

    pub fn getClFlushLineSize() u8 {
        const result = getCachedCpuid1();
        return @intCast((result.ebx >> 8) & 0xFF);
    }

    pub fn getBrandIndex() u8 {
        const result = getCachedCpuid1();
        return @intCast(result.ebx & 0xFF);
    }

    pub fn hasLocalApic() bool {
        const result = getCachedCpuid1();
        return (result.edx & (1 << 9)) != 0;
    }
};
