' 16/04/24 Test roNodeJS and roHtmlWidget Standalone version - RLB


Sub Main()

	version = "3.2"
	m.msgPort = CreateObject("roMessagePort")
	m.sTime = createObject("roSystemTime")
	gpioPort = CreateObject("roControlPort", "BrightSign")
	gpioPort.SetPort(m.msgPort)	

	b = CreateObject("roByteArray")
	b.FromHexString("ffffffff")
	color_spec% = (255*256*256*256) + (b[1]*256*256) + (b[2]*256) + b[3]

	m.videoMode = CreateObject("roVideoMode")
	m.videoMode.SetBackgroundColor(color_spec%)
	m.videomode.Setmode("1920x1080x50p")	
	
	Print " @@@ Version - " version

    m.InitNodeJS = InitNodeJS
	m.PluginInitHTMLWidgetStatic = PluginInitHTMLWidgetStatic
	m.VKInit = VKInit
	m.StartInitVKTimer = StartInitVKTimer
	m.TargetURL = "file:///pluginNodeApp/index.html"

	FilesOnStorage = ListDir("/")
	fileIndex% = 0
	nodefolderFound = false

	for each file in FilesOnStorage
		print "FilesOnStorage"; FilesOnStorage[fileIndex%]
		if FilesOnStorage[fileIndex%] = "pluginNodeApp" then
			print "pluginNodeApp Folder found"
			nodefolderFound = true
			Exit for
		end if 	
		fileIndex% = fileIndex% + 1
	next 	

	if nodefolderFound = false then
		Print "Should create pluginNodeApp folder here"
		createDirectory("sd:/pluginNodeApp")
	end if 	

	fileIndex% = 0
	VKfolderFound = false

	for each file in FilesOnStorage
		'print "FilesOnStorage"; FilesOnStorage[fileIndex%]
		if FilesOnStorage[fileIndex%] = "virtualKeyboard" then
			print "virtualKeyboard Folder found"
			VKfolderFound = true
			Exit for
		end if 	
		fileIndex% = fileIndex% + 1
	next 	

	if VKfolderFound = false then
		Print "Should create virtualKeyboardp folder here"
		m.keyboardPackage = createObject("roBrightPackage", "sd:/keyboard.zip")
		createDirectory("sd:/virtualKeyboard")
		m.keyboardPackage.unpack("virtualKeyboard/")
	end if 	
	
	StartInitNodeJSTimer()
	StartInitHTMLWidgetTimer()

	while true
	    
		msg = wait(0, m.msgPort)
		
		print "type of msgPort is ";type(msg)
		if type(msg) = "roTimerEvent" then	
			timerIdentity = msg.GetSourceIdentity()
			print "Timer msgPort Received " + stri(timerIdentity)
			if type (m.InitNodeJSTimer) = "roTimer" then 
				if m.InitNodeJSTimer.GetIdentity() = msg.GetSourceIdentity() then	
					m.InitNodeJS()
				end if
			end if	
			if type (m.InitHTMLWidgetTimer) = "roTimer" then 
				if m.InitHTMLWidgetTimer.GetIdentity() = msg.GetSourceIdentity() then	
					m.PluginInitHTMLWidgetStatic()
				end if
			end if	

			if type(m.InitVKTimer) = "roTimer" then 
				if m.InitVKTimer.GetIdentity() = msg.GetSourceIdentity() then	
					m.VKInit()
					'm.PluginInitHTMLWidgetStatic()
				end if
			end if	
		else if type(msg) = "roControlDown" then
		
			button = msg.GetInt()
				
			if button = 12 then 
				print " @@@ GPIO 12 pressed @@@  "
				stop
			end if			
		else if type(msg) = "roNodeJsEvent" then
			print " @@@ roNodeJsEvent @@@ "
			print msg.GetData()	

		else if type(msg) = "roVirtualKeyboardEvent" then
			print "event=";msg.GetData().reason
			if msg.GetData().reason = "show-event"
			  ?"show: ";m.virtualKeyboard.show()
			end if
			if msg.GetData().reason = "hide-event"
			  ?"hide: ";m.virtualKeyboard.hide()
			end if
		else if type(msg) = "roHtmlWidgetEvent" then
			eventData = msg.GetData()
			userData = msg.GetUserData()
			if type(eventData) = "roAssociativeArray" and type(eventData.reason) = "roString" then
				Print "roHtmlWidgetEvent = " , eventData.reason
				if eventData.reason = "load-finished" then
					print "load-finished WidgetName: ", userData.WidgetName	
				end if
			end if		
		end if				
	end while
End Sub



Function StartInitNodeJSTimer()
	
	print " Set StartInitNodeJSTimer Timer..."
	newTimeout = m.sTime.GetLocalDateTime()
	newTimeout.AddSeconds(1)
	m.InitNodeJSTimer = CreateObject("roTimer")
	m.InitNodeJSTimer.SetPort(m.msgPort)
	m.InitNodeJSTimer.SetDateTime(newTimeout)
	ok = m.InitNodeJSTimer.Start()
End Function



Function InitNodeJS()

	'm.node_js = CreateObject("roNodeJs", "rl_main.js", {message_port: m.msgPort, arguments: []}) ' no inspector loaded
	m.node_js = CreateObject("roNodeJs", "sd:/pluginNodeApp/bundle.js", {message_port: m.msgPort, node_arguments: ["--inspect=0.0.0.0:3001"]}) 'just for loading the inspector
	'm.node_js = CreateObject("roNodeJs", "rl_main.js", {message_port: m.msgPort, node_arguments: ["--inspect-brk=0.0.0.0:2999"]}) 'stops at breakpoints

	if type(m.node_js)<>"roNodeJs" then 
        print " @@@ Error: failed to create roNodeJs  @@@"
	else
		print " @@@ roNodeJs successfully created  @@@"
	end if
End Function


Function StartInitHTMLWidgetTimer()
	
	'print " Set StartInitHTMLWidgetTimer..."
	
	newTimeout = m.sTime.GetLocalDateTime()
	newTimeout.AddSeconds(5)
	m.InitHTMLWidgetTimer = CreateObject("roTimer")
	m.InitHTMLWidgetTimer.SetPort(m.msgPort)
	m.InitHTMLWidgetTimer.SetDateTime(newTimeout)
	ok = m.InitHTMLWidgetTimer.Start()
End Function



Function PluginInitHTMLWidgetStatic()

	userdata = {}
    userdata.WidgetName = "PluginHTMLWidget"

	'does not seem to work for iframes
	'filepath$ = "sd:/pluginNodeApp/Login.js"

	m.PluginRect = CreateObject("roRectangle", 0,0,1920,1080)
	
	is = {
		port: 2999
	}
	m.config = {
		nodejs_enabled: true
		security_params: {
			websecurity: false
		},
	
		javascript_injection: { 
		   document_creation: [], 
			'document_ready: [{source: filepath$ }],
			document_ready: [], 
			'deferred: [{source: filepath$ }]
			deferred: []
		},
		javascript_enabled: true,
		port: m.msgPort,
		inspector_server: is,
		brightsign_js_objects_enabled: true,
		url: m.TargetURL,
		mouse_enabled: true,
		transform: "rot90"
		' storage_quota: "20000000000",
		' storage_path: "/CacheFolder",
		'user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36"
	}
	
	m.PluginHTMLWidget = CreateObject("roHtmlWidget", m.PluginRect, m.config)
	m.PluginHTMLWidget.SetUserData(userdata)
	m.PluginHTMLWidget.Show()

	m.StartInitVKTimer()
End Function




Function VKInit()

	m.virtualKeyboard = invalid
	vm = m.videomode
	width = vm.getresx()
	height = vm.getresy()
	m.rectangle = createObject("rorectangle", 0, 0, width, height)
	m.virtualKeyboard = createObject("roVirtualKeyboard", m.rectangle)
	m.virtualKeyboard.setTransform("rot90")
	'm.virtualKeyboard.setTransform("rot270")
	m.virtualKeyboard.setResource("file:///virtualKeyboard/bsvirtualkb.html")
	m.virtualKeyboard.setPort(m.msgPort)
	m.virtualKeyboard.hide()
End Function



	
Function StartInitVKTimer()

	print " Set StartInitVKTimer..."

	newTimeout = m.sTime.GetLocalDateTime()
	newTimeout.AddSeconds(2)
	m.InitVKTimer = CreateObject("roTimer")
	m.InitVKTimer.SetPort(m.msgPort)
	m.InitVKTimer.SetDateTime(newTimeout)
	ok = m.InitVKTimer.Start()
End Function

