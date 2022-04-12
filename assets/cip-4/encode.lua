-- Encode a number in the format specified by CIP-4
-- Author: Guilherme Dantas <guilherme.dantas@cartesi.io>
-- Usage: lua encode.lua [number]
-- If no number is given, reads stdin

-- Convert a positive integer to a big-endian list of bits
-- Returns a big-endian list of bits
local function tobits(n)
    local bits = {}
    while n > 0 do
        table.insert(bits, n % 2)
        n = n // 2
    end
    return bits
end

-- Encode an integer in the format specified by CIP-4
-- On success, returns a big-endian list of bits
-- On failure, returns false and an error message
local function encode(n)
    if n >= 0 then
        local bits = tobits(n)
        local bytes = math.max(1, (#bits + 6) // 7)
        if bytes <= 4 then
            while #bits < bytes * 7 do
                table.insert(bits, 0)
            end
            table.insert(bits, 0)
            while #bits < bytes * 8 do
                table.insert(bits, 1)
            end
            return bits
        else
            return false, "too big"
        end
    else
        return false, "negative"
    end
end

local s = arg and arg[1] or io.stdin:read()
local n = assert(math.tointeger(s), "not an integer")
local bits = assert(encode(n))
for i = #bits, 1, -1 do
    io.stdout:write(bits[i])
end
io.stdout:write('\n')
