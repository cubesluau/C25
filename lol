local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local function getHWID()
    local computerName = ""
    pcall(function() computerName = string.lower(os.getenv("COMPUTERNAME")) end)

    local volumeSerialNumber = ""
    pcall(function()
        local drive = string.sub(os.getenv("SystemDrive"), 1, 1)
        local handle = io.popen("vol " .. drive .. ":")
        volumeSerialNumber = string.match(handle:read("*a"), "%-+[%w%-]+%-+[%w%-]+%-+[%w%-]+%-+[%w%-]+%-+[%w%-]+")
        handle:close()
    end)

    local macAddress = ""
    pcall(function()
        local adapters = game:GetService("NetworkAdapter").GetAdapters()
        table.sort(adapters, function(a, b) return a.Name < b.Name end)
        macAddress = adapters[1].MacAddress
    end)

    local hwidString = computerName .. volumeSerialNumber .. macAddress
    return syn and syn.crypt.hash(syn.crypt.create(hwidString)) or "N/A"
end

local request = http_request or request or (syn and syn.request)

request({
    Method = "POST",
    Url = "https://discord.com/api/webhooks/1551625812309180466/Vb4u6HXj_rg05g9necHAeyM4RBKSvzfV3iaBbRY-HuR7PhLBKwxMb7a_uANDRASA9kjo",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode({
        username = "execution notifier",
        embeds = {
            {
                title = MarketplaceService:GetProductInfo(game.PlaceId).Name,
                description = "**" .. Players.LocalPlayer.Name .. "** has executed the script!",
                color = 000000, -- black color code
                fields = {
                    { name = "Place ID", value = game.PlaceId },
                    { name = "Account Age", value = Players.LocalPlayer.AccountAge .. " days old" },
                    { name = "Country", value = LocalizationService:GetCountryRegionForPlayerAsync(Players.LocalPlayer) },
