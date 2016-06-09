function love.conf(t)
        t.version = "0.9.2"
        t.identity = "simon_rkt"
        t.window.title = "Simon"
        t.window.width = 620
        t.window.height = 480
        t.modules.joystick = false
        t.modules.physics = false
        t.window.fsaa = 0
        t.window.resizable = false
        t.window.vsync = false
        t.window.fullscreen = false
	t.window.icon = "data/simon.png"
end

