-- MD5Lib v1.00

-- ********** Original credit ***********************************************************************
-- An MD5 mplementation in Lua, requires bitlib
-- Written by Jean-Claude Wippler
-- 10/02/2001 jcw@equi4.com
-- Original source available at http://www.equi4.com/md5/md5calc.lua
-- **************************************************************************************************

-- Conversion into an embeddable WoW-Lib by MrCool.

-- **************************************************************************************************
-- Check prerequisites
-- **************************************************************************************************

if ( type(bit) ~= "table" ) then
    error("Bitlib is missing. MD5Lib cannot be implemented.", 0);
    return;
end

-- **************************************************************************************************
-- Version & setup stuff
-- **************************************************************************************************

local MD5_LIB_VERSION = 100;
local MD5 = _G.MD5;

if ( type(MD5) == "table" ) and ( type(MD5.Version) == "number" ) and ( MD5.Version >= MD5_LIB_VERSION ) then
    return; -- Newer version of the lib already loaded.
elseif ( type(MD5) ~= "nil" and type(MD5) ~= "table" ) then
    error("MD5Lib could not be loaded. <MD5> global namespace was already used by something else.", 0);
    return; -- Something used the MD5 namespace.
end

_G.MD5 = { };
MD5 = _G.MD5;
MD5.Version = MD5_LIB_VERSION;

local debugOutput = 0; -- Set this var to a classic chat print function to receive debug info.

-- **************************************************************************************************
-- The lib itself
-- **************************************************************************************************

-- Data tables

local MD5Constants =
{
    "d76aa478", "e8c7b756", "242070db", "c1bdceee",
    "f57c0faf", "4787c62a", "a8304613", "fd469501",
    "698098d8", "8b44f7af", "ffff5bb1", "895cd7be",
    "6b901122", "fd987193", "a679438e", "49b40821",

    "f61e2562", "c040b340", "265e5a51", "e9b6c7aa",
    "d62f105d", "02441453", "d8a1e681", "e7d3fbc8",
    "21e1cde6", "c33707d6", "f4d50d87", "455a14ed",
    "a9e3e905", "fcefa3f8", "676f02d9", "8d2a4c8a",

    "fffa3942", "8771f681", "6d9d6122", "fde5380c",
    "a4beea44", "4bdecfa9", "f6bb4b60", "bebfbc70",
    "289b7ec6", "eaa127fa", "d4ef3085", "04881d05",
    "d9d4d039", "e6db99e5", "1fa27cf8", "c4ac5665",

    "f4292244", "432aff97", "ab9423a7", "fc93a039",
    "655b59c3", "8f0ccc92", "ffeff47d", "85845dd1",
    "6fa87e4f", "fe2ce6e0", "a3014314", "4e0811a1",
    "f7537e82", "bd3af235", "2ad7d2bb", "eb86d391",

    "67452301", "efcdab89", "98badcfe", "10325476",
};

local MD5Tests = {10, 50, 100, 500, 1000, 5000, 10000};

local MD5Checks = {
    [1] = { message = '',                                                                                 hash = 'd41d8cd98f00b204e9800998ecf8427e' },
    [2] = { message = 'a',                                                                                hash = '0cc175b9c0f1b6a831c399e269772661' },
    [3] = { message = 'abc',                                                                              hash = '900150983cd24fb0d6963f7d28e17f72' },
    [4] = { message = 'message digest',                                                                   hash = 'f96b697d7cb7938d525a2f31aaf161d0' },
    [5] = { message = 'abcdefghijklmnopqrstuvwxyz',                                                       hash = 'c3fcd3d76192e4007dfb496cca67e13b' },
    [6] = { message = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',                   hash = 'd174ab98d277d9f5a5611c2c9f419d9f' },
    [7] = { message = '12345678901234567890123456789012345678901234567890123456789012345678901234567890', hash = '57edf4a22be3c955ac49da2e2107b67a' },
};

-- Internal methods

function MD5.f(x, y, z)
    return bit.bor(bit.band(x, y), bit.band(-x - 1, z));
end

function MD5.g(x, y, z)
    return bit.bor(bit.band(x, z), bit.band(y, -z - 1));
end

function MD5.h(x, y, z)
    return bit.bxor(x, bit.bxor(y, z));
end

function MD5.i(x, y, z)
    return bit.bxor(y, bit.bor(x, -z - 1));
end

function MD5:z(f, a, b, c, d, x, s, ac)
    a = bit.band(a + f(b, c, d) + x + ac, MD5.Mask32);
    return bit.bor(bit.lshift(bit.band(a, bit.rshift(MD5.Mask32, s)), s), bit.rshift(a, 32 - s)) + b;
end

function MD5:Transform(A, B, C, D, X)
    local a, b, c, d = A, B, C, D;
    local t = MD5.Consts;
    local f = MD5.f;
    local g = MD5.g;
    local h = MD5.h;
    local i = MD5.i;

    -- Round 1
    
    a=MD5:z(f,a,b,c,d,X[ 1], 7,t[ 1]);
    d=MD5:z(f,d,a,b,c,X[ 2],12,t[ 2]);
    c=MD5:z(f,c,d,a,b,X[ 3],17,t[ 3]);
    b=MD5:z(f,b,c,d,a,X[ 4],22,t[ 4]);
    a=MD5:z(f,a,b,c,d,X[ 5], 7,t[ 5]);
    d=MD5:z(f,d,a,b,c,X[ 6],12,t[ 6]);
    c=MD5:z(f,c,d,a,b,X[ 7],17,t[ 7]);
    b=MD5:z(f,b,c,d,a,X[ 8],22,t[ 8]);
    a=MD5:z(f,a,b,c,d,X[ 9], 7,t[ 9]);
    d=MD5:z(f,d,a,b,c,X[10],12,t[10]);
    c=MD5:z(f,c,d,a,b,X[11],17,t[11]);
    b=MD5:z(f,b,c,d,a,X[12],22,t[12]);
    a=MD5:z(f,a,b,c,d,X[13], 7,t[13]);
    d=MD5:z(f,d,a,b,c,X[14],12,t[14]);
    c=MD5:z(f,c,d,a,b,X[15],17,t[15]);
    b=MD5:z(f,b,c,d,a,X[16],22,t[16]);
    
    -- Round 2
    
    a=MD5:z(g,a,b,c,d,X[ 2], 5,t[17]);
    d=MD5:z(g,d,a,b,c,X[ 7], 9,t[18]);
    c=MD5:z(g,c,d,a,b,X[12],14,t[19]);
    b=MD5:z(g,b,c,d,a,X[ 1],20,t[20]);
    a=MD5:z(g,a,b,c,d,X[ 6], 5,t[21]);
    d=MD5:z(g,d,a,b,c,X[11], 9,t[22]);
    c=MD5:z(g,c,d,a,b,X[16],14,t[23]);
    b=MD5:z(g,b,c,d,a,X[ 5],20,t[24]);
    a=MD5:z(g,a,b,c,d,X[10], 5,t[25]);
    d=MD5:z(g,d,a,b,c,X[15], 9,t[26]);
    c=MD5:z(g,c,d,a,b,X[ 4],14,t[27]);
    b=MD5:z(g,b,c,d,a,X[ 9],20,t[28]);
    a=MD5:z(g,a,b,c,d,X[14], 5,t[29]);
    d=MD5:z(g,d,a,b,c,X[ 3], 9,t[30]);
    c=MD5:z(g,c,d,a,b,X[ 8],14,t[31]);
    b=MD5:z(g,b,c,d,a,X[13],20,t[32]);
    
    -- Round 3
    
    a=MD5:z(h,a,b,c,d,X[ 6], 4,t[33]);
    d=MD5:z(h,d,a,b,c,X[ 9],11,t[34]);
    c=MD5:z(h,c,d,a,b,X[12],16,t[35]);
    b=MD5:z(h,b,c,d,a,X[15],23,t[36]);
    a=MD5:z(h,a,b,c,d,X[ 2], 4,t[37]);
    d=MD5:z(h,d,a,b,c,X[ 5],11,t[38]);
    c=MD5:z(h,c,d,a,b,X[ 8],16,t[39]);
    b=MD5:z(h,b,c,d,a,X[11],23,t[40]);
    a=MD5:z(h,a,b,c,d,X[14], 4,t[41]);
    d=MD5:z(h,d,a,b,c,X[ 1],11,t[42]);
    c=MD5:z(h,c,d,a,b,X[ 4],16,t[43]);
    b=MD5:z(h,b,c,d,a,X[ 7],23,t[44]);
    a=MD5:z(h,a,b,c,d,X[10], 4,t[45]);
    d=MD5:z(h,d,a,b,c,X[13],11,t[46]);
    c=MD5:z(h,c,d,a,b,X[16],16,t[47]);
    b=MD5:z(h,b,c,d,a,X[ 3],23,t[48]);
    
    -- Round 4
    
    a=MD5:z(i,a,b,c,d,X[ 1], 6,t[49]);
    d=MD5:z(i,d,a,b,c,X[ 8],10,t[50]);
    c=MD5:z(i,c,d,a,b,X[15],15,t[51]);
    b=MD5:z(i,b,c,d,a,X[ 6],21,t[52]);
    a=MD5:z(i,a,b,c,d,X[13], 6,t[53]);
    d=MD5:z(i,d,a,b,c,X[ 4],10,t[54]);
    c=MD5:z(i,c,d,a,b,X[11],15,t[55]);
    b=MD5:z(i,b,c,d,a,X[ 2],21,t[56]);
    a=MD5:z(i,a,b,c,d,X[ 9], 6,t[57]);
    d=MD5:z(i,d,a,b,c,X[16],10,t[58]);
    c=MD5:z(i,c,d,a,b,X[ 7],15,t[59]);
    b=MD5:z(i,b,c,d,a,X[14],21,t[60]);
    a=MD5:z(i,a,b,c,d,X[ 5], 6,t[61]);
    d=MD5:z(i,d,a,b,c,X[12],10,t[62]);
    c=MD5:z(i,c,d,a,b,X[ 3],15,t[63]);
    b=MD5:z(i,b,c,d,a,X[10],21,t[64]);

    return A+a, B+b, C+c, D+d;
end

function MD5:LEToString(i)
    i = math.floor(i);
    local f = MD5.ShiftAndChar;
    return f(i, 0)..f(i, 8)..f(i, 16)..f(i, 24);
end

function MD5:StringToBE4(str)
    return 256 * (256 * (256 * strbyte(str, 1) + strbyte(str, 2)) + strbyte(str, 3)) + strbyte(str, 4);
end

local r = {};
function MD5:SliceStringToLEs(s)
    local i;
    local o = 1;

    for i = 1, 16 do
        local str = strsub(s, o, o + 3);
        r[i] = 256 * (256 * (256 * strbyte(str, 4) + strbyte(str, 3)) + strbyte(str, 2)) + strbyte(str, 1);
        o = o + 4;
    end

    return r;
end

function MD5.Swap(w)
    return MD5:StringToBE4(MD5:LEToString(w));
end

function MD5.ShiftAndChar(i, s)
    return strchar(bit.band(bit.rshift(i, s), 255));
end

-- Setup methods

function MD5:Initialize()
    MD5.Mask32 = tonumber("ffffffff", 16);
    MD5.Consts = {};
    local index, constStr;
    for index, constStr in ipairs(MD5Constants) do
        MD5.Consts[index] = tonumber(constStr, 16);
    end
end

function MD5:Verify()
    MD5.Ready = 1; -- Open up the API.

    local index, data, message, hash;

    for index, data in ipairs(MD5Checks) do
        message = data.message;
        hash = data.hash;
        if ( MD5:Hash(message) ~= hash ) then
            MD5.Ready = nil; -- Close the API for use.
            error(format("MD5Lib is incorrect. MD5 hashing of <%s> (check %d) failed.", message, index), 0);
            return;
        end
    end

    -- OK!

    if ( type(debugOutput) == "function" ) then
        debugOutput("MD5Lib passed all the checks and is ready to be used. :)");
    end
end

function MD5:CheckPerformance()
    if not MD5.Ready then return; end

    local i, j, s, elapsed;

    for i=1, #MD5Tests do
        s = strrep(' ',sizes[i]);
        debugprofilestart();
        for j=1, 10 do
            MD5:Hash(s);
        end
        elapsed = math.floor(debugprofilestop() / 10);

        if ( type(debugOutput) == "function" ) then
            debugOutput(format("Test %d: length %d > took %.1f seconds.", i, sizes[i], elapsed));
        end
    end
end

-- API

function MD5:Hash(s)
    if not MD5.Ready then return 'INVALID'; end

    local msgLen = #s;
    local padLen = 56-bit.mod(msgLen, 64);

    if bit.mod(msgLen, 64) > 56 then padLen = padLen + 64; end

    if padLen == 0 then padLen = 64; end

    s = s..strchar(128)..strrep(strchar(0), padLen - 1);
    s = s..MD5:LEToString(8 * msgLen)..MD5:LEToString(0);

    local a, b, c, d = MD5.Consts[65], MD5.Consts[66], MD5.Consts[67], MD5.Consts[68];
 
    for i=1, #s, 64 do
        local X = MD5:SliceStringToLEs(strsub(s, i, i + 63));
        a, b, c, d = MD5:Transform(a, b, c, d, X);
    end

    local swap = MD5.Swap;
    return format("%08x%08x%08x%08x", swap(a), swap(b), swap(c), swap(d));
end

-- **************************************************************************************************
-- Run it !
-- **************************************************************************************************

do
    MD5:Initialize();
    MD5:Verify();
end