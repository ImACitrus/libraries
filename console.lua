local console = {}
console.__index = console

console.DATA = {
    Name = "Console",
    Color = "@@RED@@"
    colors = {
        black="@@BLACK@@",
        blue="@@BLUE@@",
        green="@@GREEN@@",
        cyan="@@CYAN@@",
        magenta="@@MAGENTA@@",
        brown="@@BROWN@@",
        yellow="@@YELLOW@@",
        white="@@WHITE@@"
        ["light gray"]="@@LIGHT_GRAY@@",
        ["dark gray"]="@@DARK_GRAY@@",
        ["light blue"]="@@LIGHT_BLUE@@",
        ["light green"]="@@LIGHT_GREEN@@",
        ["light cyan"]="@@LIGHT_CYAN@@",
        ["light red"]="@@LIGHT_RED@@",
        ["light magenta"]="@@LIGHT_MAGENTA@@"
    }
}

function console:Message(message, color)
    rconsoleprint(console.DATA.colors[string.lower(color)])
    rconsoleprint(message)
end

function console:Clear(onClear)
    if onClear and type(onClear) == "function" then
        rconsoleclear()
        onClear()
    end
    rconsoleclear()
end

function console:Alert(message, method)
    if string.lower(method) == "warn" then
        rconsolewarn(message)
    elseif string.lower(method) == "error" then
        rconsoleerr(message)
    else
        rconsoleerr("Unsupported method, clearing in 5s")
        task.wait(5)
        rconsoleclear()
    end
end

function console:Internal(message, data)
    printconsole(message, data[1] or 255, data[2] or 255, data[3] or 255)
end

function console:await_input(onMessage)
    onMessage(rconsoleinput)
end

return console
