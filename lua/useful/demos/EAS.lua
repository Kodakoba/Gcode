
local w, h = ScrW(), ScrH()

local static = Material("effects/tvscreen_noise002a")
static:SetVector("$color", Vector(0.1, 0.1, 0.1))
static:SetFloat("$refract", 0.05)

local lines = 15
local gap = h * 0.04
local mat = draw.RenderOntoMaterial("scanline", w, h/lines, function(w, h)
    surface.SetDrawColor(255, 255, 255)
    surface.DrawRect(0, gap / 2, w, h - gap / 2)
end, function(rt)
    render.BlurRenderTarget(rt, 0, 4, 4)
end)

local off = 0
local hdH = 0

local pronounce = "This is not a test. This is your emergency broadcast system announcing the commencement of the Annual No Nut November. All pornography has been restricted. Males with birthdays during No Nut November have been granted immunity and shall be allowed to nut on the day of their birth. Commencing at the siren, any and all nutting, including masturbation, sex, and other sorts of sexual activities will be illegal for 30 consecutive days. Prostitution, Porn websites, other porn media outlets, and girls will be unavailable for use until December, when No Nut November concludes. Blessed be our New Founding Fathers and America, a nation reborn. May Allah be with you all."
local scrollText = "This is not a test. This is your emergency broadcast system announcing the commencement of the Annual No Nut November." 
local mainText = "This is not a test.\nThis is the announcement of\nthe commencement of the\nAnnual No Nut November."

surface.SetFont("SYD72")
local scrollW = surface.GetTextSize(scrollText)
local scrollsIn = #scrollText * 0.15
local loopTime = 3.6

local dl = Promise(function(res)
    hdl.DownloadFile("https://vaati.net/Gachi/eas.mp3", "sfx/eas.dat", res, error)
end)

local rdy = false
local need = false

local API = "10df66dc79124749bf3368e1ee90e88e"
local function gen(tx)
    local url = "https://api.voicerss.org"
    url = url:format(API, tx)

    http.Post(url, {
        key = API,
        hl = "en-us",
        c = "MP3",
        v = "John",
        f = "16khz_16bit_mono",
        src = tx:gsub("[\n$*]", ""),
    },
    function(b)
        file.Write("hdl/sfx/cursedTTS.dat", b)
    end, error)
end

gen(pronounce)

if IsValid(EAS_AlertStream) then EAS_AlertStream:Stop() end
if IsValid(EAS_TTSStream) then EAS_TTSStream:Stop() end

local function play()

    sound.PlayFile("data/hdl/sfx/eas.dat", "", function(s, err)
        if err then error("you retarded bruv " .. err) return end

        if IsValid(EAS_AlertStream) then EAS_AlertStream:Stop() end
        if IsValid(EAS_TTSStream) then EAS_TTSStream:Stop() end

        EAS_AlertStream = s
        timer.Simple(15, function()
            if IsValid(EAS_TTSStream) then EAS_TTSStream:Stop() end

            s:Pause()
            sound.PlayFile("data/hdl/sfx/cursedTTS.dat", "", function(s2, err)
                if err then error("you retarded bruv " .. err) return end
                EAS_TTSStream = s2
                timer.Simple(s2:GetLength(), function()
                    if IsValid(EAS_AlertStream) then EAS_AlertStream:Stop() end
                    if IsValid(EAS_TTSStream) then EAS_TTSStream:Stop() end
                end)
            end)
        end)
    end)

end


dl:Then(function()
    rdy = true
    if need then
        play()
    end
end):Exec()

local states = {

    blackout = {
        Start = 0,
        End = 1,
        Paint = function()
            surface.SetDrawColor(color_black:Unpack())
            surface.DrawRect(0, 0, w, h)
        end
    },

    intro = {
        Start = 1,
        End = 5151,
        Paint = function()

            surface.SetDrawColor(color_black:Unpack())
            surface.DrawRect(0, 0, w, h)

            local speed = 0.3
            off = off + (FrameTime() * (0.5 + math.random() / 2) * speed) % 10

            surface.SetMaterial(mat)
            surface.SetDrawColor(60, 60, 60, 1)
            surface.DrawTexturedRectUV(0, 0, w, h, 0, off, 1, lines + off)

            local _, tH = draw.SimpleText("NATIONAL ALERT", "SYD72", w/2, h*0.1, color_white, 1)
            hdH = tH

            --draw.SimpleText2("Primary Entry Point System", nil, w/2, h*0.2 + hdH * 2 + h * 0.05, color_white, 1)

            for s, line in eachNewline(mainText) do

                if s:match("%$") then s = s:match("[^$]+") end
                if #s <= 0 then break end
                draw.SimpleText2(s, nil, w/2, h*0.1 + hdH * 2 + h * 0.2 + line * hdH, color_white, 1)
            end
            --[[draw.SimpleText("Issued an", "SYD72", w/2, h*0.1 + hdH * 3 + h * 0.2, color_white, 1)
            draw.SimpleText("Emergency Action", "SYD72", w/2, h*0.1 + hdH * 3 + h * 0.35, color_white, 1)
            draw.SimpleText("Notification", "SYD72", w/2, h*0.1 + hdH * 3.875 + h * 0.35, color_white, 1)]]
        end,
    },

    sound = {
        Start = 1 + 1,
        End = 5151,

        OnActive = function()
            need = true
            if rdy then
                play()
            end
        end
    },

    scroller = {
        Start = 1 + 1.5,
        End = 5151,

        Paint = function(tsb)
            local whereFrac = (tsb % (scrollsIn + loopTime)) / scrollsIn
            local where = whereFrac * (scrollW + w * 0.8) 

            draw.BeginMask()
                surface.SetDrawColor(0, 0, 0)
                surface.DrawRect(w * 0.2, hdH + 4, w * 0.6, h)
            draw.DrawOp()
                draw.SimpleText(scrollText:match("[^*]+"), "SYD72", (w * 0.8) - where, h*0.1 + hdH, color_white)
            draw.FinishMask()
        end,

    }

}

local st = SysTime()

local ordered = {}

for k,v in pairs(states) do
    ordered[#ordered + 1] = k
end

table.sort(ordered, function(a, b)
    return states[a].Start < states[b].Start
end)

hook.Add("HUDPaint", "BRRR", function()
    local ct = SysTime()
    local ss = ct - st

    for num, stateName in ipairs(ordered) do
        local state = states[stateName]
        local act = ss > state.Start and ss < state.End

        if act and not state.Active then
            if state.OnActive then state.OnActive() end
        elseif not act and state.Active then
            if state.OnDeactive then state.OnDeactive() end
        end

        local activeFor = ss - state.Start
        state.Active = act

        if act and state.Paint then
            state.Paint(activeFor)
        end
    end

end)

concommand.Add("die", Curry(hook.Remove, "HUDPaint", "BRRR"))