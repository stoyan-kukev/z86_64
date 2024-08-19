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
    pub const CpuFeatures = struct {
        sse3: bool,
        pclmulqdq: bool,
        monitor: bool,
        ssse3: bool,
        fma: bool,
        cmpxchg16b: bool,
        sse41: bool,
        sse42: bool,
        popcnt: bool,
        aes: bool,
        xsave: bool,
        osxsave: bool,
        avx: bool,
        f16c: bool,
    };

    var cached_result: ?CpuidResult = null;

    fn getCachedCpuid1() CpuidResult {
        if (cached_result == null) {
            cached_result = cpuid(1);
        }

        return cached_result.?;
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

    pub fn getCpuFeatures() CpuFeatures {
        const result = getCachedCpuid1();
        const ecx = result.ecx;

        return CpuFeatures{
            .sse3 = (ecx & (1 << 0)) != 0,
            .pclmulqdq = (ecx & (1 << 1)) != 0,
            .monitor = (ecx & (1 << 3)) != 0,
            .ssse3 = (ecx & (1 << 9)) != 0,
            .fma = (ecx & (1 << 12)) != 0,
            .cmpxchg16b = (ecx & (1 << 13)) != 0,
            .sse41 = (ecx & (1 << 19)) != 0,
            .sse42 = (ecx & (1 << 20)) != 0,
            .popcnt = (ecx & (1 << 23)) != 0,
            .aes = (ecx & (1 << 25)) != 0,
            .xsave = (ecx & (1 << 26)) != 0,
            .osxsave = (ecx & (1 << 27)) != 0,
            .avx = (ecx & (1 << 28)) != 0,
            .f16c = (ecx & (1 << 29)) != 0,
        };
    }
};
