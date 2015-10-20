
Config = require "../config/Config.coffee"
Renderer = require "../gfx/Renderer.coffee"

HeavyAudioInterface = require "../heavy/HeavyAudioInterface.coffee"

MuseumScene = require "../scenes/MuseumScene.coffee"
# DisplaySocketHandler = require "../display/DisplaySocketHandler.coffee"

DebugView = require "../debug/DebugView.coffee"
MapView = require "../mapView/MapView.coffee"

IntroPage = require "../pages/IntroPage.coffee"

class TuneInApp
	constructor:()->

		@debugView = DebugView
		@debugView.init()

		@userCountElement = $ "userCount"

		@renderer = new Renderer $ "renderer"
		@scene = new MuseumScene()

		@map = new MapView($("map"))
		@audio = new HeavyAudioInterface(testLib)

		@introPage = new IntroPage()

		@loaded = false


	init:()=>

		window.addEventListener "resize", @resize
		window.addEventListener "orientationchange", @resize

		@resize()

		@scene.on "loaded", @onSceneLoaded
		@scene.init("./json/Map01.json")


	onSceneLoaded:()=>

		@map.init(@scene.mapData)
		@scene.on "userPosition", @onUserPositionChange
		@scene.on "userAngle", @onUserAngleChange

		@audio.on "loaded", @onAudioLoaded
		@audio.init()
		

	onAudioLoaded:()=>

		# setup params for testLib
		@audio.sendFloat "pwm-freq", 0.5
		@audio.sendFloat "note-1", 0.5
		@audio.sendFloat "ba", 0.5
		@audio.sendFloat "pwm-amt", 0.5
		@audio.sendFloat "note-2", 0.5
		@audio.sendFloat "positions", 0.5
		@audio.sendFloat "transpose", 0.5
		@audio.sendFloat "note-3", 0.5
		@audio.sendFloat "hh", 0.5
		@audio.sendFloat "listener-direction", 0.5
		@audio.sendFloat "listener-y", 0.5
		@audio.sendFloat "listener-x", 0.5
		@audio.sendFloat "kick", 0.5
		@audio.sendFloat "note-0", 0.5

		@audio.reset()
		@renderer.init(@scene.scene, @scene.camera)
		
		@introPage.init("intro", "./html/intro.html", document.body.querySelector("#container"))
		@introPage.on("loaded", @onIntroLoaded)

	onIntroLoaded:()=>
		# @introPage.show()
		@scene.enableControls()
		@loaded = true
		# @introPage.on("hide", ()=>
			
		# 	@scene.enableControls()
		# 	)
		
	
	onUserPositionChange:(data)=>
		@map.setUserPosition(data.x, data.y)
		@audio.sendFloat "listener-x", data.x * 32
		@audio.sendFloat "listener-y", data.y * 32

	onUserAngleChange:(angle)=>
		@map.setUserAngle(angle)
		
		# angle conversion for pd
		angle-=90
		angle = angle % 360
		if angle < 0 then angle += 360
		@audio.sendFloat "listener-direction", angle

	render:()=>

		if @loaded

			@scene.cameraAnchor.set(
				0,
				0,
				@debugView.settings.cameraZ
				)

			@scene.update()

			@renderer.render @scene

	resize:()=>
		if @loaded
			@renderer.resize()


module.exports = TuneInApp