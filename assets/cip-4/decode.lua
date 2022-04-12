-- Decode a number in the format specified by CIP-4
-- Author: Guilherme Dantas <guilherme.dantas@cartesi.io>
-- Usage: lua decode.lua [number]
-- If no number is given, reads stdin

-- Convert a big-endian list of bits to a positive integer
-- Returns a positive integer
local function frombits(bits)
    local n = 0
    for i = #bits, 1, -1 do
        n = 2 * n + bits[i]
    end
    return n
end

-- Decode an integer in the format specified by CIP-4
-- On success, returns a non-negative integer
-- On failure, returns false and an error message
local function decode(bits)
    local bytes = 0
    for i = #bits, 1, -1 do
        bytes = bytes + 1
        if bits[i] == 0 then
            break
        end
    end
    if bytes < 1 or bytes > 4 then
        return false, "invalid number of bits"
    end
    for i = 1, bytes do
        bits[#bits - i + 1] = nil
    end
    return frombits(bits)
end

local function tobits(s)
    local bits = {}
    for i = #s, 1, -1 do
        local bit = assert(math.tointeger(s:sub(i, i)), "not a number")
        assert(bit == 0 or bit == 1, "not a bit")
        table.insert(bits, bit)
    end
    return bits
end

local s = arg and arg[1] or io.stdin:read()
local bits = tobits(s)
local n = assert(decode(bits))
print(n)
