GLSettings = require './GLSettings.coffee'

RenderSettings = require './RenderSettings.coffee'

class Renderer
	constructor: ( container ) ->
		@renderer = new THREE.WebGLRenderer { antialias: true }
		@renderer.setClearColor 0xffffff, 1
		@renderer.shadowMapEnabled = true
		@renderer.shadowMapType = THREE.PCFSoftShadowMap
		@renderer.physicallyBasedShading = true
		@renderer.gammaInput = true
		@renderer.gammeOutput = true

		@glSettings = new GLSettings @renderer.context
		#console.log @glSettings.capabilities

		# # check if it's a beefy gpu
		# maxTexSize = @glSettings.capabilities.maxTexSize
		# if (maxTexSize > 16000)
		# 	@renderer.setPixelRatio window.devicePixelRatio
		# else
		# 	@renderer.setPixelRatio 1

		container.appendChild @renderer.domElement

		

		# if !@glSettings.capabilities.dds
		# 	console.warn "Compressed Textures not supported. You'll be using low-res JPG instead"

		# @shadowMapEnabled = true

		# if @shadowMapEnabled
		# 	@renderer.shadowMapEnabled = true
		# 	@renderer.shadowMapType = THREE.PCFSoftShadowMap

		# if window.addEventListener
		# 	window.addEventListener 'resize', ( e ) =>
		# 		@resize()
		# 	, false

		# else if window.attachEvent
		# 	window.attachEvent 'resize', ( e ) =>
		# 		@resize()
		# 	, false

		



		

	init:(@scene, @camera)=>

		@resize()


		# @depthShader = THREE.ShaderLib["depthRGBA"]
		# @depthUniforms = THREE.UniformsUtils.clone(@depthShader.uniforms)

		# @depthMaterial = new THREE.ShaderMaterial( { fragmentShader : @depthShader.fragmentShader, vertexShader : @depthShader.vertexShader, uniforms : @depthUniforms })

		# @composer = new THREE.EffectComposer(@renderer)
		# @renderPass = new THREE.RenderPass @scene, @camera
		# # @renderPass.renderToScreen = true
		# @composer.addPass @renderPass

		# # @cameraControls = new THREE.OrbitControls(@camera)

		# @depthTarget = new THREE.WebGLRenderTarget( 512, 512, { minFilter: THREE.LinearFilter, magFilter: THREE.LinearFilter, format: THREE.RGBAFormat } )
				
		# @ssaoEffect = new THREE.ShaderPass( THREE.SSAOShader )
		# @ssaoEffect.uniforms[ 'tDepth' ].value = @depthTarget
		# @ssaoEffect.uniforms[ 'size' ].value.set( 512, 512 )
		# @ssaoEffect.uniforms[ 'cameraNear' ].value = @camera.near
		# @ssaoEffect.uniforms[ 'cameraFar' ].value = @camera.far
		# @ssaoEffect.renderToScreen = true
		# @composer.addPass( @ssaoEffect )


		# @renderPass = new THREE.RenderPass(@scene, @camera)
		# @renderPass.renderToScreen = true
		# @composer.addPass(@renderPass)


		# @rgbShift = new THREE.ShaderPass(THREE.RGBShiftShader)
		# @rgbShift.uniforms['amount'].value = 0.0005
		# @rgbShift.renderToScreen = true
		# @composer.addPass(@rgbShift)

		# @rgbShift = new THREE.ShaderPass(THREE.VignetteShader)
		# @rgbShift.renderToScreen = true
		# @composer.addPass(@rgbShift)

		

	render: ( scene=null ) ->

		# @cameraControls.update()

		# scene.scene.overrideMaterial = @depthMaterial
		# @renderer.render scene.scene, scene.camera, @depthTarget

		# scene.scene.overrideMaterial = null
		# @composer.render()
		@renderer.render scene.scene, @camera
		# 

	resize: () ->
		r = RenderSettings.getRect()
		w = r.width()
		h = r.height()
		@renderer.setSize w, h
		@camera.aspect = w/h
		@camera.updateProjectionMatrix()
		@renderer.domElement.style.left = "#{r.x1}px"
		@renderer.domElement.style.top = "#{r.y1}px"

	mouseMove: (x, y) ->
		@newMouseX = x
		@newMouseY = y

module.exports = Renderer;