#cs ----------------------------------------------------------------------------

AutoIt Version: 3.3.14.2
Author:       Minggui Lu

Script Function:
  Helpdesk_Automatic_configuration_Tool

关于Helpdesk_Automatic_configuration_Tool
Helpdesk_Automatic_configuration_Tool是一款Helpdesk桌面运维自动化配置的工具，由类BASIC语言的AutoIt v3 脚本编写，用于简化Helpdesk大量繁复的操作，通过GUI交互，实现以下功能，大幅解放Helpdesk桌面工程师的时间和精力，用于更高的技术学习和提升。
1. 自动设置系统选项
2. 客户端自动加域
3. 自动安装软件
4. 自动重启电脑并登录域账户
5. 自动配置桌面环境
6. 自动配置outlook及skype等

配置说明：
以下代码位于134 ~ 144行，user-defined部分请根据实际需求和场景自定义

Global $rootUserName = "administrator" ;本地管理员administrator
Global $rootPassword = "user-defined"  ;本地管理员密码

Global $createUserName = "admin"  ;创建本地用户名
Global $createUserPassword = "user-defined" ;设置本地用户名密码

Global $domainName = "user-defined" ;AD域名，
Global $itUserName = "user-defined" ;IT管理员域账户
Global $itPassword = "user-defined" ;IT管理员域账户密码

Global $fileSrvPath = "user-defined" ;安装文件所在的共享目录地址

Global $userName	 ;用户域账号
Global $userPassword ;用户域账户密码
Global $hostName     ;用户计算机名

使用说明：
1. 该自动化运维工具适用于Microsoft Windows 7、Windows 8、Windows 10系统，结合企业级系统部署平台MDT使用更优
2. 配置选项用于根据不同部门员工的桌面使用需求自动进行系统设置、安装软件等初始化操作，需在administraor账户下运行
3. 用户选项用于根据不用部门员工的桌面使用需求自动进行桌面环境配置，outlook、skype等办公软件登录设置，需在用于账户下运行
4. 自动重启系统+登录账户 通过授予用户本地管理员权限并修改注册表实现，在系统重启自动登录用户账户后，需运行取消自动登录 和 取消管理员权限来重置注册表并从administrators组移出用户账户
5. 可根据各自公司内部的实际桌面运维需求，修改该脚本代码，从而添加、修改或删除自动化功能模块
6. 所需安装的软件和工具下载放置于$fileSrvPath下，并根据存放路径和软件名称修改对应模块的代码

技术支持：
QQ: 3251076037

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;;请求管理员权限
#RequireAdmin

;#include <ButtonConstants.au3>
;#include <GUIConstantsEx.au3>
;#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GuiButton.au3>

; 切换为 OnEvent 模式
Opt("GUIOnEventMode", 1)

_main()

GUISetState()

Func _main()

   Global $Checkbox[53]

   Global $gui_width = 490
   Global $gui_height = 500

   Global $checkbox_left = 5
   Global $sysconf_top = 10
   Global $install_top = 155
   Global $user_top = 375
   Global $checkbox_width = 150
   Global $checkbox_height = 20

   Global $select_left = 5
   Global $select_top = 300
   Global $select_width = 50
   Global $select_height = 30

   GUICreate("自动化配置工具 V1.0  - By Miguel Louis", $gui_width, $gui_height)

   GUICtrlCreateGroup("系统设置", $checkbox_left, $sysconf_top, $gui_width-10, $gui_height/3-30)
   $Checkbox[1] = GUICtrlCreateCheckbox("修改计算机名并加域", $checkbox_left+5, $sysconf_top+20, $checkbox_width, $checkbox_height)
   $Checkbox[2] = GUICtrlCreateCheckbox("修改管理员密码", $checkbox_left+160, $sysconf_top+20, $checkbox_width, $checkbox_height)
   $Checkbox[3] = GUICtrlCreateCheckbox("创建本地用户admin", $checkbox_left+320, $sysconf_top+20, $checkbox_width, $checkbox_height)
   $Checkbox[4] = GUICtrlCreateCheckbox("添加IT管理员组", $checkbox_left+5, $sysconf_top+50, $checkbox_width, $checkbox_height)
   $Checkbox[5] = GUICtrlCreateCheckbox("开启远程桌面", $checkbox_left+160, $sysconf_top+50, $checkbox_width, $checkbox_height)
   $Checkbox[6] = GUICtrlCreateCheckbox("安装AD证书", $checkbox_left+320, $sysconf_top+50, $checkbox_width, $checkbox_height)
   $Checkbox[7] = GUICtrlCreateCheckbox("激活Office", $checkbox_left+5, $sysconf_top+80, $checkbox_width, $checkbox_height)
   $Checkbox[8] = GUICtrlCreateCheckbox("降低UAC等级", $checkbox_left+160, $sysconf_top+80, $checkbox_width, $checkbox_height)

   GUICtrlCreateGroup("软件安装", $checkbox_left, $install_top, $gui_width-10, $gui_height/3-30)
   $Checkbox[21] = GUICtrlCreateCheckbox("Adobe Flash Player", $checkbox_left+5, $install_top+20, $checkbox_width, $checkbox_height)
   $Checkbox[22] = GUICtrlCreateCheckbox("Google Chrome", $checkbox_left+160, $install_top+20, $checkbox_width, $checkbox_height)
   $Checkbox[23] = GUICtrlCreateCheckbox("LinPhone for Windows", $checkbox_left+320, $install_top+20, $checkbox_width, $checkbox_height)
   $Checkbox[24] = GUICtrlCreateCheckbox("Cisco VPN Client", $checkbox_left+5, $install_top+50, $checkbox_width, $checkbox_height)
   $Checkbox[25] = GUICtrlCreateCheckbox("Minerva Pro", $checkbox_left+160, $install_top+50, $checkbox_width, $checkbox_height)
   $Checkbox[26] = GUICtrlCreateCheckbox("Avaya one-X", $checkbox_left+320, $install_top+50, $checkbox_width, $checkbox_height)
   $Checkbox[27] = GUICtrlCreateCheckbox("Teamviewer11to10", $checkbox_left+5, $install_top+80, $checkbox_width, $checkbox_height)
   $Checkbox[28] = GUICtrlCreateCheckbox("Teamviewer10", $checkbox_left+160, $install_top+80, $checkbox_width, $checkbox_height)

   GUICtrlCreateGroup("配置选项",$select_left, $select_top, $gui_width-10, $gui_height/3-100)
   Global $Radio1 = GUICtrlCreateRadio("销售", $select_left+5, $select_top+20, $select_width, $select_height)
   Global $Radio2 = GUICtrlCreateRadio("销售(含VPN)", $select_left+55, $select_top+20, $select_width+40, $select_height)
   Global $Radio3 = GUICtrlCreateRadio("运营", $select_left+150, $select_top+20, $select_width, $select_height)
   Global $Radio4 = GUICtrlCreateRadio("售后", $select_left+200, $select_top+20, $select_width, $select_height)

   GUICtrlCreateGroup("用户选项",$select_left, $user_top, $gui_width-10, $gui_height/3-100)
   $Checkbox[43] = GUICtrlCreateCheckbox("销售", $checkbox_left+5, $user_top+20, $checkbox_width-100, $checkbox_height+10)
   $Checkbox[44] = GUICtrlCreateCheckbox("运营", $checkbox_left+65, $user_top+20, $checkbox_width-100, $checkbox_height+10)
   $Checkbox[45] = GUICtrlCreateCheckbox("售后", $checkbox_left+135, $user_top+20, $checkbox_width-100, $checkbox_height+10)
   $Checkbox[41] = GUICtrlCreateCheckbox("取消自动登录", $checkbox_left+205, $user_top+20, $checkbox_width-50, $checkbox_height+10)
   $Checkbox[42] = GUICtrlCreateCheckbox("取消管理员权限", $checkbox_left+305, $user_top+20, $checkbox_width-50, $checkbox_height+10)

   $Checkbox[51] = GUICtrlCreateCheckbox("自动重启系统+登录账户", $select_left+90, $user_top+85, $select_width+100, $select_height)
   Global $Radio11 = GUICtrlCreateRadio("全选", $select_left+260, $user_top+85, $select_width, $select_height)
   Global $Radio12 = GUICtrlCreateRadio("全不选", $select_left+320, $user_top+85, $select_width+10, $select_height)

   Global $Button1 = GUICtrlCreateButton("运行 (&A)", $select_left, $user_top+80, $select_width+20, $select_height)
   Global $Button2 = GUICtrlCreateButton("退出 (&E)", $select_left+410, $user_top+80, $select_width+20, $select_height)


   GUICtrlSetOnEvent($Radio1,"_chooseStation")
   GUICtrlSetOnEvent($Radio2,"_chooseStationWithVPN")
   GUICtrlSetOnEvent($Radio3,"_chooseCreditAduit")
   GUICtrlSetOnEvent($Radio4,"_chooseCollection")
   GUICtrlSetOnEvent($Radio11,"_chooseAll")
   GUICtrlSetOnEvent($Radio12,"_chooseNone")
   GUICtrlSetOnEvent($Checkbox[43],"_userStation")
   GUICtrlSetOnEvent($Checkbox[44],"_userCreditAduit")
   GUICtrlSetOnEvent($Checkbox[45],"_userCollection")
   GUICtrlSetOnEvent($Button1,"_action")
   GUICtrlSetOnEvent($Button2,"_exit")
   GUISetOnEvent($GUI_EVENT_CLOSE,"_exit")

   Global $_run[53]

   $_run[1] = _run1 ;修改计算机名并加域
   $_run[2] = _run2	;修改管理员密码
   $_run[3] = _run3 ;创建Admin用户
   $_run[4] = _run4	;添加IT服务台
   $_run[5] = _run5 ;开启远程桌面
   $_run[6] = _run6 ;安装AD证书
   $_run[7] = _run7	;激活Office
   $_run[8] = _run8	;降低UAC等级

   $_run[21] = _run21 ;安装Adobe Flash Player
   $_run[22] = _run22 ;安装Google Chrome
   $_run[23] = _run23 ;安装LinPhone for Windows
   $_run[24] = _run24 ;安装Cisco VPN Client
   $_run[25] = _run25 ;安装Minerva Pro
   $_run[26] = _run26 ;安装Avaya one-X
   $_run[27] = _run27 ;卸载TeamViewer11，安装TeamViewer10
   $_run[28] = _run28 ;安装TeamViewer10

   $_run[41] = _run41 ;取消自动登录
   $_run[42] = _run42 ;取消管理员权限

   $_run[43] = _run43 ;销售用户配置
   $_run[44] = _run44 ;运营用户配置
   $_run[45] = _run45 ;售后用户配置


   $_run[51] = _run51 ;自动重启系统

   Global $rootUserName = "administrator" ;本地管理员administrator
   Global $rootPassword = "user-defined" ;本地管理员密码

   Global $createUserName = "admin" ;创建本地用户名
   Global $createUserPassword = "user-defined" ;设置本地用户名密码

   Global $domainName = "user-defined" ;AD域名，
   Global $itUserName = "user-defined" ;IT管理员域账户
   Global $itPassword = "user-defined" ;IT管理员域账户密码

   Global $fileSrvPath = "user-defined" ;安装文件所在的共享目录地址

   Global $userName	;用户域账号
   Global $userPassword ;用户域账户密码
   Global $hostName ;用户计算机名

EndFunc

While 1
   sleep(1000)
WEnd

;;关闭程序
Func _exit()
   Exit
EndFunc

;;销售
Func _chooseStation()

   For $i = 1 to 52
	  GUICtrlSetState($Checkbox[$i],4)
   Next

   GUICtrlSetState($Checkbox[1],1)
   GUICtrlSetState($Checkbox[2],1)
   GUICtrlSetState($Checkbox[3],1)
   GUICtrlSetState($Checkbox[4],1)
   GUICtrlSetState($Checkbox[5],1)
   GUICtrlSetState($Checkbox[6],1)
   GUICtrlSetState($Checkbox[7],1)

   GUICtrlSetState($Checkbox[21],1)

   GUICtrlSetState($Checkbox[51],1)

   GUICtrlSetState($Radio11,4)
   GUICtrlSetState($Radio12,4)

EndFunc

;;销售(含VPN)
Func _chooseStationWithVPN()

   For $i = 1 to 52
	  GUICtrlSetState($Checkbox[$i],4)
   Next

   GUICtrlSetState($Checkbox[1],1)
   GUICtrlSetState($Checkbox[2],1)
   GUICtrlSetState($Checkbox[3],1)
   GUICtrlSetState($Checkbox[4],1)
   GUICtrlSetState($Checkbox[5],1)
   GUICtrlSetState($Checkbox[6],1)
   GUICtrlSetState($Checkbox[7],1)

   GUICtrlSetState($Checkbox[21],1)
   GUICtrlSetState($Checkbox[24],1)

   GUICtrlSetState($Checkbox[51],1)

   GUICtrlSetState($Radio11,4)
   GUICtrlSetState($Radio12,4)

EndFunc

;;运营
Func _chooseCreditAduit()

   For $i = 1 to 52
	  GUICtrlSetState($Checkbox[$i],4)
   Next

   GUICtrlSetState($Checkbox[1],1)
   GUICtrlSetState($Checkbox[2],1)
   GUICtrlSetState($Checkbox[4],1)
   GUICtrlSetState($Checkbox[5],1)
   GUICtrlSetState($Checkbox[6],1)
   GUICtrlSetState($Checkbox[7],1)

   GUICtrlSetState($Checkbox[21],1)
   GUICtrlSetState($Checkbox[23],1)

   GUICtrlSetState($Checkbox[51],1)

   GUICtrlSetState($Radio11,4)
   GUICtrlSetState($Radio12,4)

EndFunc

;;售后
Func _chooseCollection()

   For $i = 1 to 52
	  GUICtrlSetState($Checkbox[$i],4)
   Next

   GUICtrlSetState($Checkbox[1],1)
   GUICtrlSetState($Checkbox[2],1)
   GUICtrlSetState($Checkbox[4],1)
   GUICtrlSetState($Checkbox[5],1)
   GUICtrlSetState($Checkbox[6],1)
   GUICtrlSetState($Checkbox[7],1)
   GUICtrlSetState($Checkbox[8],1)

   GUICtrlSetState($Checkbox[21],1)
   GUICtrlSetState($Checkbox[25],1)
   GUICtrlSetState($Checkbox[26],1)

   GUICtrlSetState($Checkbox[51],1)

   GUICtrlSetState($Radio11,4)
   GUICtrlSetState($Radio12,4)

EndFunc

;;选中“销售用户配置”同时选中“安装Google Chrome"
Func _userStation()
   If _GUICtrlButton_GetCheck($Checkbox[43]) Then
	  GUICtrlSetState($Checkbox[41],1)
	  GUICtrlSetState($Checkbox[42],1)
   EndIf
EndFunc

;;选中“运营用户配置”同时选中“安装Google Chrome"
Func _userCreditAduit()
   If _GUICtrlButton_GetCheck($Checkbox[44]) Then
	  GUICtrlSetState($Checkbox[22],1)
	  GUICtrlSetState($Checkbox[41],1)
	  GUICtrlSetState($Checkbox[42],1)
   EndIf
EndFunc

;;选中“售后用户配置”同时选中“安装Google Chrome"
Func _userCollection()
   If _GUICtrlButton_GetCheck($Checkbox[45]) Then
	  GUICtrlSetState($Checkbox[41],1)
	  GUICtrlSetState($Checkbox[42],1)
   EndIf
EndFunc

;;全选
Func _chooseAll()
   For $i = 1 to 40
	  GUICtrlSetState($Checkbox[$i],1)
   Next
   For $i = 41 to 46
	  GUICtrlSetState($Checkbox[$i],4)
   Next
   GUICtrlSetState($Checkbox[51],1)
   GUICtrlSetState($Radio1,4)
   GUICtrlSetState($Radio2,4)
   GUICtrlSetState($Radio3,4)
   GUICtrlSetState($Radio4,4)
   GUICtrlSetState($Radio12,4)
EndFunc

;;全不选
Func _chooseNone()
   For $i = 1 to 52
	  GUICtrlSetState($Checkbox[$i],4)
   Next
   GUICtrlSetState($Radio1,4)
   GUICtrlSetState($Radio2,4)
   GUICtrlSetState($Radio3,4)
   GUICtrlSetState($Radio4,4)
   GUICtrlSetState($Radio11,4)
EndFunc

;;运行
Func _action()
   For $i = 1 to 52
	  If _GUICtrlButton_GetCheck($Checkbox[$i]) Then
		 $_run[$i]()
	  EndIf
   Next
EndFunc

;;用户配置
Func _userConf()

   Run("C:\Program Files\Microsoft Office\Office16\OUTLOOK.EXE")
   WinWaitActive("欢迎使用 Microsoft Outlook 2016","欢迎使用 Outlook 2016")
   SLEEP(0x000001F4)
   Send("!n")
   WinWaitActive("Microsoft Outlook 账户设置","使用 Outlook 连接到电子邮件帐户")
   SLEEP(0x000001F4)
   Send("!n")
   WinWaitActive("添加帐户","电子邮件帐户(&A)")
   SLEEP(0x000003E8)
   Send("!n")
   SLEEP(0x000007D0)
   If WinExists("安全警告") Then  ;如果提示未安装域证书则自动进行安装
	  If IsAdmin() Then
		 WinMinimizeAll()

		 Run("explorer $fileSrvPath\AD\CA.cer")
		 WinWaitActive("证书","证书信息")
		 SLEEP(0x000001F4)
		 Send("!i")
		 WinWaitActive("证书导入向导","欢迎使用证书导入向导")
		 SLEEP(0x000001F4)
		 Send("!n")
		 WinWaitActive("证书导入向导","证书存储是保存证书的系统区域")
		 SLEEP(0x000001F4)
		 Send("!p")
		 SLEEP(0x000001F4)
		 Send("!r")
		 WinWaitActive("选择证书存储","选择要使用的证书存储")
		 SLEEP(0x000001F4)
		 Send("{DOWN}")
		 SLEEP(0x000001F4)
		 ControlClick("选择证书存储","选择要使用的证书存储","Button1","left",1)
		 WinWaitActive("证书导入向导","证书存储是保存证书的系统区域")
		 SLEEP(0x000001F4)
		 Send("!n")
		 WinWaitActive("证书导入向导","正在完成证书导入向导")
		 SLEEP(0x000001F4)
		 ControlClick("证书导入向导","正在完成证书导入向导","Button6","left",1)
		 Local $i = 0
		 While $i <= 3000
			If WinExists("安全性警告") Then
			   WinActivate("安全性警告","您即将从一个声称代表如下的证书颁发机构安装证书")
			   WinWaitActive("安全性警告","您即将从一个声称代表如下的证书颁发机构安装证书")
			   SLEEP(0x000001F4)
			   Send("!y")
			Else
			   SLEEP(0x000003E8)
			   $i = $i + 1000
			EndIf
		 WEnd
		 WinActivate("证书导入向导","导入成功")
		 WinWaitActive("证书导入向导","导入成功")
		 SLEEP(0x000001F4)
		 ControlClick("证书导入向导","导入成功","Button1","left",1)
		 WinWaitActive("证书","证书信息")
		 SLEEP(0x000001F4)
		 Send("!i")
		 WinWaitActive("证书导入向导","欢迎使用证书导入向导")
		 SLEEP(0x000001F4)
		 Send("!n")
		 WinWaitActive("证书导入向导","证书存储是保存证书的系统区域")
		 SLEEP(0x000001F4)
		 Send("!p")
		 SLEEP(0x000001F4)
		 Send("!r")
		 WinWaitActive("选择证书存储","选择要使用的证书存储")
		 SLEEP(0x000001F4)
		 Send("{DOWN}")
		 SLEEP(0x000001F4)
		 Send("{DOWN}")
		 SLEEP(0x000001F4)
		 Send("{DOWN}")
		 SLEEP(0x000001F4)
		 Send("{DOWN}")
		 SLEEP(0x000001F4)
		 ControlClick("选择证书存储","选择要使用的证书存储","Button1","left",1)
		 WinWaitActive("证书导入向导","证书存储是保存证书的系统区域")
		 SLEEP(0x000001F4)
		 Send("!n")
		 WinWaitActive("证书导入向导","正在完成证书导入向导")
		 SLEEP(0x000001F4)
		 ControlClick("证书导入向导","正在完成证书导入向导","Button6","left",1)
		 WinWaitActive("证书导入向导","导入成功")
		 SLEEP(0x000001F4)
		 ControlClick("证书导入向导","导入成功","Button1","left",1)
		 WinWaitActive("证书","证书信息")
		 SLEEP(0x000001F4)
		 ControlClick("证书","证书信息","Button5","left",1)
		 WinWaitClose("证书","证书信息")
	  Else
		 RunAs($rootUserName,@ComputerName,$rootPassWord,0,"certutil -addstore -f Root $fileSrvPath\AD\CA.cer","")
	  EndIf
	  WinActivate("安全警告")
	  WinWaitActive("安全警告")
	  SLEEP(0x000001F4)
	  Send("!y")
	  WinWaitActive("添加帐户","恭喜您! 您的电子邮件帐户已成功配置并已准备就绪")
	  SLEEP(0x000001F4)
	  ControlClick("添加帐户","恭喜您! 您的电子邮件帐户已成功配置并已准备就绪","Button9","left",1)
   ElseIf WinExists("添加帐户","恭喜您! 您的电子邮件帐户已成功配置并已准备就绪") Then
	  WinActivate("添加帐户","恭喜您! 您的电子邮件帐户已成功配置并已准备就绪")
	  WinWaitActive("添加帐户","恭喜您! 您的电子邮件帐户已成功配置并已准备就绪")
	  SLEEP(0x000001F4)
	  ControlClick("添加帐户","恭喜您! 您的电子邮件帐户已成功配置并已准备就绪","Button9","left",1)
   EndIf
   WinWaitActive("TeamViewer会议插件")
   SLEEP(0x000001F4)
   Send("{ENTER}")
   WinWaitClose("TeamViewer会议插件")
   WinWaitActive("首要事项")
   SLEEP(0x000001F4)
   Send("!l")
   SLEEP(0x000001F4)
   Send("!a")
   SLEEP(0x000001F4)
   WinMinimizeAll()
   SLEEP(0x000001F4)
   Run("C:\Program Files\Microsoft Office\Office16\lync.exe")
   WinWaitActive("Skype for Business","查找联系人或聊天室")

   Exit

   #cs

   SLEEP(0x000003E8)
   If WinExists("快速提示") Then
	  WinClose("快速提示")
	  WinWaitClose("快速提示")
   EndIf
   SLEEP(0x000003E8)
   If WinExists("Skype for Business","关闭程序") Then
	  WinActivate("Skype for Business","关闭程序")
	  WinWaitActive("Skype for Business","关闭程序")
	  SLEEP(0x000001F4)
	  Send("!c")
	  WinWaitClose("Skype for Business","关闭程序")
   Else
	  Exit
   EndIf

   #ce

EndFunc

;;自动登录域账户
Func _autoLogin()

   WinMinimizeAll()

   If IsAdmin() Then
	  If $userName == "" Then
		 Global $userName = InputBox("输入","请输入用户名：","")
		 Global $userPassword = InputBox("输入","请输入密码：","")
	  EndIf
	  ShellExecute(@SystemDir & "\compmgmt.msc")
	  WinWaitActive("计算机管理","计算机管理(本地)")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{RIGHT}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{TAB}")
	  SLEEP(0x000001F4)
	  Send("{ENTER}")
	  WinWaitActive("Administrators 属性","常规")
	  SLEEP(0x000001F4)
	  Send("!d")
	  WinWaitActive("选择用户、计算机、服务帐户或组","选择此对象类型(&S):")
	  SLEEP(0x000001F4)
	  ControlSetText("选择用户、计算机、服务帐户或组","选择此对象类型(&S):","RichEdit20W1",$userName)
	  SLEEP(0x000001F4)
	  Send("!c")
	  WinWaitActive("Windows 安全")
	  SLEEP(0x000001F4)
	  ControlSetText("Windows 安全","","Edit1",$itUserName)
	  SLEEP(0x000001F4)
	  ControlSetText("Windows 安全","","Edit2",$itPassword)
	  SLEEP(0x000001F4)
	  ControlClick("Windows 安全","","Button2","left",1)
	  WinWaitActive("选择用户、计算机、服务帐户或组","选择此对象类型(&S):")
	  SLEEP(0x000001F4)
	  ControlClick("选择用户、计算机、服务帐户或组","选择此对象类型(&S):","Button5","left",1)
	  WinWaitActive("Administrators 属性","常规")
	  SLEEP(0x000001F4)
	  ControlClick("Administrators 属性","常规","Button3","left",1)
	  WinActivate("计算机管理","本地用户和组\组")
	  WinWaitActive("计算机管理","本地用户和组\组")
	  SLEEP(0x000001F4)
	  WinClose("计算机管理","本地用户和组\组")
	  WinWaitClose("计算机管理","计算机管理(本地)")

	  SLEEP(0x000001F4)

	  RegWrite("HKEY_LOCAL_MACHINE64\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AutoAdminLogon", "REG_SZ", "1")
	  RegWrite("HKEY_LOCAL_MACHINE64\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultDomainName", "REG_SZ", $domainName)
	  RegWrite("HKEY_LOCAL_MACHINE64\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultUserName", "REG_SZ", $userName)
	  RegWrite("HKEY_LOCAL_MACHINE64\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "Defaultpassword", "REG_SZ", $userPassword)
   Else
	  ;RunAs($rootUserName,@ComputerName,$rootPassword,0,ShellExecute(@SystemDir & "\compmgmt.msc"))
	  MsgBox(64,"警告","当前用户无权操作本地管理员组！",2)
   EndIf

EndFunc

;;自动重启
Func _autoReboot()

   WinMinimizeAll()

   MsgBox(64,"提示","已完成初始化配置！系统将自动重启！",3)

   Shutdown(6)

EndFunc

;;修改计算机名并加域
Func _run1()

   WinMinimizeAll()

   SLEEP(0x000003E8)

   Global $userName = InputBox("输入","请输入用户名：","")
   Global $userPassword = InputBox("输入","请输入密码：","")
   Global $hostName = InputBox("输入","请输入计算机名：","")

   If IsAdmin() Then
	  Run("control sysdm.cpl")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,"control sysdm.cpl")
   EndIf
   WinWaitActive("系统属性","计算机名")
   SLEEP(0x000001F4)
   Send("!c")
   WinWaitActive("计算机名/域更改","计算机名(&C):")
   SLEEP(0x000001F4)
   WinActivate("计算机名/域更改","计算机名(&C):")
   ControlSetText("计算机名/域更改","计算机名(&C):","Edit1",$hostName)
   SLEEP(0x000001F4)
   ControlCommand("计算机名/域更改","计算机名(&C):","Button3","Check")
   SLEEP(0x000001F4)
   ControlSetText("计算机名/域更改","计算机名(&C):","Edit3",$domainName)
   SLEEP(0x000001F4)
   ControlClick("计算机名/域更改","计算机名(&C):","Button6","left",1)
   WinWaitActive("Windows 安全")
   SLEEP(0x000001F4)
   ControlSetText("Windows 安全","","Edit1",$itUserName)
   SLEEP(0x000001F4)
   ControlSetText("Windows 安全","","Edit2",$itPassword)
   SLEEP(0x000001F4)
   ControlClick("Windows 安全","","Button2","left",1)
   WinWaitActive("计算机名/域更改","欢迎加入")
   SLEEP(0x000001F4)
   ControlClick("计算机名/域更改","欢迎加入","Button1","left",1)
   Local $i = 0
   While $i <= 8000
	  If WinExists("计算机名/域更改","帐户名与安全标识间无任何映射完成") Then
		 WinActivate("计算机名/域更改","帐户名与安全标识间无任何映射完成")
		 WinWaitActive("计算机名/域更改","帐户名与安全标识间无任何映射完成")
		 SLEEP(0x000001F4)
		 Send("{ENTER}")
		 ExitLoop
	  Else
		 SLEEP(0x000003E8)
		 $i = $i + 1000
	  EndIf
   WEnd
   WinWaitActive("计算机名/域更改","确定")
   SLEEP(0x000001F4)
   Send("{ENTER}")
   WinWaitActive("系统属性","计算机名")
   SLEEP(0x000001F4)
   ControlClick("系统属性","计算机名","Button3","left",1)
   WinWaitActive("Microsoft Windows")
   SLEEP(0x000001F4)
   Send("!l")
   WinWaitClose("Microsoft Windows")

EndFunc

;;修改本地管理员密码
Func _run2()

   WinMinimizeAll()

   If IsAdmin() Then
	  Run("net user administrator " & $rootPassword)
	  SLEEP(0x000003E8)
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,"net user administrator " & $rootPassword,"")
	  SLEEP(0x000003E8)
   EndIf

EndFunc

;;创建admin用户
Func _run3()

   WinMinimizeAll()

   If IsAdmin() Then
	  Run("net user " & $createUserName & " " & $createUserPassword & " /add")
	  Run("net localgroup users " & $createUserName & " /add")
	  ShellExecute(@SystemDir & "\compmgmt.msc")
	  WinWaitActive("计算机管理","计算机管理(本地)")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{RIGHT}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{TAB}")
	  SLEEP(0x000001F4)
	  Send("{ENTER}")
	  WinWaitActive("admin 属性","常规")
	  SLEEP(0x000001F4)
	  ControlCommand("admin 属性","常规","Button2","Check","")
	  SLEEP(0x000001F4)
	  ControlCommand("admin 属性","常规","Button3","Check","")
	  SLEEP(0x000001F4)
	  ControlClick("admin 属性","常规","Button6","left",1)
	  WinActivate("计算机管理","计算机管理(本地)")
	  WinWaitActive("计算机管理","计算机管理(本地)")
	  SLEEP(0x000001F4)
	  WinClose("计算机管理","计算机管理(本地)")
	  WinWaitClose("计算机管理","计算机管理(本地)")
   Else
	  ;RunAs($rootUserName,@ComputerName,$rootPassword,0,"net user admin Password@1 /add /passwordchg:no","")
	  ;RunAs($rootUserName,@ComputerName,$rootPassword,0,"net localgroup users admin /add","")
	  ;RunAs($rootUserName,@ComputerName,$rootPassword,0,ShellExecute(@SystemDir & "\compmgmt.msc"))
	  MsgBox(64,"警告","当前用户无权操作本地账户！",2)
   EndIf

EndFunc

;;添加ITservice组至administrators组
Func _run4()

   WinMinimizeAll()

   If IsAdmin() Then
	  ShellExecute(@SystemDir & "\compmgmt.msc")
	  WinWaitActive("计算机管理","计算机管理(本地)")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{RIGHT}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{TAB}")
	  SLEEP(0x000001F4)
	  Send("{ENTER}")
	  WinWaitActive("Administrators 属性","常规")
	  SLEEP(0x000001F4)
	  Send("!d")
	  WinWaitActive("选择用户、计算机、服务帐户或组","选择此对象类型(&S):")
	  SLEEP(0x000001F4)
	  ControlSetText("选择用户、计算机、服务帐户或组","选择此对象类型(&S):","RichEdit20W1","itservice")
	  SLEEP(0x000001F4)
	  Send("!c")
	  WinWaitActive("Windows 安全")
	  SLEEP(0x000001F4)
	  ControlSetText("Windows 安全","","Edit1",$itUserName)
	  SLEEP(0x000001F4)
	  ControlSetText("Windows 安全","","Edit2",$itPassword)
	  SLEEP(0x000001F4)
	  ControlClick("Windows 安全","","Button2","left",1)
	  WinWaitActive("选择用户、计算机、服务帐户或组","选择此对象类型(&S):")
	  SLEEP(0x000001F4)
	  ControlClick("选择用户、计算机、服务帐户或组","选择此对象类型(&S):","Button5","left",1)
	  Local $i = 0
	  While $i <= 1000
		 If WinExists("本地用户和组",'"IT服务台" 已经在列表中') Then
			WinActivate("本地用户和组",'"IT服务台" 已经在列表中')
			WinWaitActive("本地用户和组",'"IT服务台" 已经在列表中')
			SLEEP(0x000001F4)
			ControlClick("本地用户和组",'"IT服务台" 已经在列表中',"Button1","left",1)
			ExitLoop
		 Else
			SLEEP(0x000001F4)
			$i = $i + 500
		 EndIf
	  WEnd
	  WinWaitActive("Administrators 属性","常规")
	  SLEEP(0x000001F4)
	  ControlClick("Administrators 属性","常规","Button3","left",1)
	  WinActivate("计算机管理","本地用户和组\组")
	  WinWaitActive("计算机管理","本地用户和组\组")
	  SLEEP(0x000001F4)
	  WinClose("计算机管理","本地用户和组\组")
	  WinWaitClose("计算机管理","计算机管理(本地)")
   Else
	  ;RunAs($rootUserName,@ComputerName,$rootPassword,0,ShellExecute(@SystemDir & "\compmgmt.msc"))
	  MsgBox(64,"警告","当前用户无权操作本地管理员组！",2)
   EndIf

EndFunc

;;开启远程桌面
Func _run5()

   WinMinimizeAll()

   If IsAdmin() Then
	  Run("control sysdm.cpl")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,"control sysdm.cpl")
   EndIf
   WinWaitActive("系统属性","计算机名")
   SLEEP(0x000001F4)
   Send("+{TAB}")
   SLEEP(0x000001F4)
   Send("{RIGHT}")
   SLEEP(0x000001F4)
   Send("{RIGHT}")
   SLEEP(0x000001F4)
   Send("{RIGHT}")
   SLEEP(0x000001F4)
   Send("{RIGHT}")
   WinWaitActive("系统属性","远程")
   SLEEP(0x000001F4)
   ControlCommand("系统属性","远程","Button2","Check","")
   SLEEP(0x000001F4)
   ControlCommand("系统属性","远程","Button6","Check","")
   SLEEP(0x000001F4)
   $tempRemoteTitle = WinGetTitle("")
   If $tempRemoteTitle == "远程桌面" Then
	  WinActivate($tempRemoteTitle)
	  WinWaitActive($tempRemoteTitle)
	  SLEEP(0x000001F4)
	  ControlClick($tempRemoteTitle,"","Button1","left",1)
   EndIf
   WinWaitActive("系统属性","远程")
   SLEEP(0x000001F4)
   Send("!a")
   SLEEP(0x000001F4)
   ControlClick("系统属性","远程","Button9","left",1)
   WinWaitClose("系统属性","远程")

EndFunc

;;安装AD证书
Func _run6()

   WinMinimizeAll()

   If IsAdmin() Then
	  Run("explorer $fileSrvPath\AD\CA.cer")
	  WinWaitActive("证书","证书信息")
	  SLEEP(0x000001F4)
	  Send("!i")
	  WinWaitActive("证书导入向导","欢迎使用证书导入向导")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive("证书导入向导","证书存储是保存证书的系统区域")
	  SLEEP(0x000001F4)
	  Send("!p")
	  SLEEP(0x000001F4)
	  Send("!r")
	  WinWaitActive("选择证书存储","选择要使用的证书存储")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  ControlClick("选择证书存储","选择要使用的证书存储","Button1","left",1)
	  WinWaitActive("证书导入向导","证书存储是保存证书的系统区域")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive("证书导入向导","正在完成证书导入向导")
	  SLEEP(0x000001F4)
	  ControlClick("证书导入向导","正在完成证书导入向导","Button6","left",1)
	  Local $i = 0
	  While $i <= 3000
		 If WinExists("安全性警告") Then
			WinActivate("安全性警告","您即将从一个声称代表如下的证书颁发机构安装证书")
			WinWaitActive("安全性警告","您即将从一个声称代表如下的证书颁发机构安装证书")
			SLEEP(0x000001F4)
			Send("!y")
		 Else
			SLEEP(0x000003E8)
			$i = $i + 1000
		 EndIf
	  WEnd
	  WinActivate("证书导入向导","导入成功")
	  WinWaitActive("证书导入向导","导入成功")
	  SLEEP(0x000001F4)
	  ControlClick("证书导入向导","导入成功","Button1","left",1)
	  WinWaitActive("证书","证书信息")
	  SLEEP(0x000001F4)
	  Send("!i")
	  WinWaitActive("证书导入向导","欢迎使用证书导入向导")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive("证书导入向导","证书存储是保存证书的系统区域")
	  SLEEP(0x000001F4)
	  Send("!p")
	  SLEEP(0x000001F4)
	  Send("!r")
	  WinWaitActive("选择证书存储","选择要使用的证书存储")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  ControlClick("选择证书存储","选择要使用的证书存储","Button1","left",1)
	  WinWaitActive("证书导入向导","证书存储是保存证书的系统区域")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive("证书导入向导","正在完成证书导入向导")
	  SLEEP(0x000001F4)
	  ControlClick("证书导入向导","正在完成证书导入向导","Button6","left",1)
	  WinWaitActive("证书导入向导","导入成功")
	  SLEEP(0x000001F4)
	  ControlClick("证书导入向导","导入成功","Button1","left",1)
	  WinWaitActive("证书","证书信息")
	  SLEEP(0x000001F4)
	  ControlClick("证书","证书信息","Button5","left",1)
	  WinWaitClose("证书","证书信息")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,"certutil -addstore -f Root $fileSrvPath\AD\awesomitCA.cer","")
   EndIf

EndFunc

;;激活Office
Func _run7()

   WinMinimizeAll()

   If IsAdmin() Then
	  Run($fileSrvPath & "\Microsoft\KMSpico\KMSpico_setup\KMSpico_setup.exe")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassWord,0,$fileSrvPath & "\Microsoft\KMSpico\KMSpico_setup\KMSpico_setup.exe","")
   EndIf
   WinWaitActive("Setup","Welcome to the KMSpico Setup Wizard")
   SLEEP(0x000001F4)
   If WinExists("Microsoft Security Essentials","注意") Then
	  WinClose("Microsoft Security Essentials","注意")
	  WinWaitClose("Microsoft Security Essentials","注意")
	  WinWaitActive("")
   EndIf
   Send("!n")
   WinWaitActive("Setup","License Agreement")
   SLEEP(0x000001F4)
   If WinExists("Microsoft Security Essentials","注意") Then
	  WinClose("Microsoft Security Essentials","注意")
	  WinWaitClose("Microsoft Security Essentials","注意")
	  WinWaitActive("")
   EndIf
   Send("!a")
   SLEEP(0x000001F4)
   Send("!n")
   WinWaitActive("Setup","Select Destination Location")
   SLEEP(0x000001F4)
   If WinExists("Microsoft Security Essentials","注意") Then
	  WinClose("Microsoft Security Essentials","注意")
	  WinWaitClose("Microsoft Security Essentials","注意")
	  WinWaitActive("")
   EndIf
   Send("!n")
   WinWaitActive("Setup","Select Start Menu Folder")
   SLEEP(0x000001F4)
   If WinExists("Microsoft Security Essentials","注意") Then
	  WinClose("Microsoft Security Essentials","注意")
	  WinWaitClose("Microsoft Security Essentials","注意")
	  WinWaitActive("")
   EndIf
   Send("!n")
   SLEEP(0x000003E8)
   If WinExists("Setup","Preparing to Install") Then
	  WinActivate("Setup","Preparing to Install")
	  WinWaitActive("Setup","Preparing to Install")
	  SLEEP(0x000001F4)
	  Send("{ESC}")
	  WinWaitActive("Exit Setup","Setup is not complete")
	  SLEEP(0x000001F4)
	  Send("!y")
	  WinWaitClose("Exit Setup","Setup is not complete")
   Else
	  If WinExists("Error","中止(&A)") Then
		 WinActivate("Error","中止(&A)")
		 WinWaitActive("Error","中止(&A)")
		 SLEEP(0x000001F4)
		 Send("!a")
		 WinWaitClose("Error","中止(&A)")
	  Else
		 ;WinWaitClose("Setup","installing")
		 WinWaitClose("Setup - KMSpico")
	  EndIf
   EndIf

   #comments-start

   If WinExists("Setup","Preparing to Install") Then
	  WinActivate("Setup","Preparing to Install")
	  WinWaitActive("Setup","Preparing to Install")
	  SLEEP(0x000001F4)
	  Send("{ESC}")
	  WinWaitActive("Exit Setup","Setup is not complete")
	  SLEEP(0x000001F4)
	  Send("!y")
	  WinWaitClose("Exit Setup","Setup is not complete")
   ElseIf WinExists("Error","中止(&A)") Then
	  WinActivate("Error","中止(&A)")
	  WinWaitActive("Error","中止(&A)")
	  SLEEP(0x000001F4)
	  Send("!a")
	  WinWaitClose("Error","中止(&A)")
   Else
	  ;WinWaitClose("Setup","installing")
	  WinWaitClose("Setup - KMSpico")
   EndIf

   #comments-end

EndFunc

;;降低UAC等级
Func _run8()

   WinMinimizeAll()

   If IsAdmin() Then
	  Send("#r")
	  WinWaitActive("运行")
	  SLEEP(0x000001F4)
	  ControlSetText("运行","","Edit1","msconfig")
	  SLEEP(0x000001F4)
	  ControlClick("运行","","Button2","left",1)
	  WinWaitActive("系统配置","常规")
	  SLEEP(0x000001F4)
	  Send("^{TAB}")
	  SLEEP(0x000001F4)
	  Send("^{TAB}")
	  SLEEP(0x000001F4)
	  Send("^{TAB}")
	  SLEEP(0x000001F4)
	  Send("^{TAB}")
	  WinWaitActive("系统配置","工具")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("!l")
	  WinWaitActive("用户帐户控制设置")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  ControlClick("用户帐户控制设置","","Button1","left",1)
	  WinWaitActive("系统配置","工具")
	  SLEEP(0x000001F4)
	  ControlClick("系统配置","工具","Button30","left",1)
	  WinWaitClose("系统配置","工具")
   Else
	  MsgBox(64,"提示","当前用户无权操作UAC，请切换本地管理员账户操作！",2)
   EndIf

EndFunc

;;预留
;;Func _run9()
;;Func _run10()
;;Func _run11()
;;Func _run12()
;;Func _run13()
;;Func _run14()
;;Func _run15()
;;Func _run16()
;;Func _run17()
;;Func _run18()
;;Func _run19()
;;Func _run20()



;;安装Adobe Flash Player
Func _run21()

   WinMinimizeAll()

   If IsAdmin() Then
	  Run($fileSrvPath & "\Adobe\Flash\flashplayer_install.exe")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,$fileSrvPath & "\Adobe\Flash\flashplayer_install.exe","")
   EndIf
   WinWaitActive("")
   Local $tempFlashTitle = WinGetTitle("")
   WinWaitActive($tempFlashTitle,"我已经阅读并同意")
   SLEEP(0x000001F4)
   ControlCommand($tempFlashTitle,"我已经阅读并同意","Button4","Check","")
   SLEEP(0x000001F4)
   ControlClick($tempFlashTitle,"我已经阅读并同意","Button2","left",1)
   WinWaitActive("")
   Local $tempFlashText = WinGetText("")
   If StringInStr($tempFlashText,"下列发生冲突的应用程序") Then
	  ControlClick($tempFlashTitle,"下列发生冲突的应用程序","Button1","left",1)
	  WinWaitClose($tempFlashTitle,"下列发生冲突的应用程序")
	  MsgBox(64,"提示","请关闭IE浏览器后再尝试运行安装程序！",2)
   Else
	  WinWaitActive($tempFlashTitle,"Flash Player 2")
	  SLEEP(0x000001F4)
	  ControlClick($tempFlashTitle,"Flash Player 2","Button2","left",1)
	  WinWaitClose($tempFlashTitle,"Flash Player 2")
   EndIf

   EndFunc

;;安装Google Chrome
Func _run22()

   WinMinimizeAll()

   Run($fileSrvPath & "\Google\chrome_installer.exe")
   WinWaitActive("欢迎使用 Chrome - Google Chrome","Chrome Legacy Window")
   SLEEP(0x000003E8)
   WinClose("欢迎使用 Chrome - Google Chrome")
   WinWaitClose("欢迎使用 Chrome - Google Chrome")

EndFunc

;;安装Linphone
Func _run23()

   WinMinimizeAll()

   If IsAdmin() Then
	  Run($fileSrvPath & "\LinPhone\Linphone-3.10.2-win32.exe")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,$fileSrvPath & "\LinPhone\Linphone-3.10.2-win32.exe","")
   EndIf
   WinWaitActive("")
   Local $tempLinphoneText = WinGetText("")
   Local $tempResult = StringInStr($tempLinphoneText,"installed",0,1)
   If $tempResult Then
	  WinActivate("Linphone 3.10.2 安装","Linphone is already installed")
	  WinWaitActive("Linphone 3.10.2 安装","Linphone is already installed")
	  SLEEP(0x000001F4)
	  ControlClick("Linphone 3.10.2 安装","Linphone is already installed","Button2","left",1)
	  WinWaitClose("Linphone 3.10.2 安装","Linphone is already installed")
   Else
	  WinActivate("Linphone 3.10.2 安装","欢迎使用“Linphone 3.10.2”安装向导")
	  WinWaitActive("Linphone 3.10.2 安装","欢迎使用“Linphone 3.10.2”安装向导")
	  SLEEP(0x000001F4)
	  Send("!n")
	  SLEEP(0x000001F4)
	  WinWaitActive("Linphone 3.10.2 安装","许可证协议")
	  SLEEP(0x000001F4)
	  Send("!i")
	  SLEEP(0x000001F4)
	  WinWaitActive("Linphone 3.10.2 安装","选择安装位置")
	  SLEEP(0x000001F4)
	  Send("!n")
	  SLEEP(0x000001F4)
	  WinWaitActive("Linphone 3.10.2 安装",'选择“开始菜单”文件夹')
	  SLEEP(0x000001F4)
	  Send("!n")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive("Linphone 3.10.2 安装","选择组件")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{SPACE}")
	  SLEEP(0x000001F4)
	  Send("!i")
	  WinWaitActive("Linphone 3.10.2 安装",'正在完成“Linphone 3.10.2”安装向导')
	  SLEEP(0x000003E8)
	  Send("!f")
	  WinWaitClose("Linphone 3.10.2 安装",'正在完成“Linphone 3.10.2”安装向导')
   EndIf

EndFunc

;;安装Cisco VPN
Func _run24()

   WinMinimizeAll()

   If IsAdmin() Then
	  Run($fileSrvPath & "\Cisco\Cisco.VPN.Client.v5.0.07.0290.x64\setup.exe")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,$fileSrvPath & "\Cisco\Cisco.VPN.Client.v5.0.07.0290.x64\setup.exe","")
   EndIf
   WinWaitActive("WinZip Self-Extractor - setup.exe","To unzip all files in setup.exe")
   SLEEP(0x000001F4)
   ControlClick("WinZip Self-Extractor - setup.exe","To unzip all files in setup.exe","Button4","left",1)
   WinWaitActive("WinZip Self-Extractor","确定")
   SLEEP(0x000001F4)
   ControlClick("WinZip Self-Extractor","确定","Button1","left",1)
   WinWaitActive("Cisco Systems VPN Client 5.0.07.0290","This installation can be displayed in multiple languages")
   SLEEP(0x000001F4)
   ControlClick("Cisco Systems VPN Client 5.0.07.0290","This installation can be displayed in multiple languages","Button1","left",1)
   SLEEP(0x000003e8)
   If WinExists("Installer Information","Error 28000:") Then
	  WinActivate("Installer Information","Error 28000: Before installing the Cisco Systems VPN Client 5.0.07.0290")
	  WinWaitActive("Installer Information","Error 28000: Before installing the Cisco Systems VPN Client 5.0.07.0290")
	  SLEEP(0x000001F4)
	  ControlClick("Installer Information","Error 28000: Before installing the Cisco Systems VPN Client 5.0.07.0290","Button1","left",1)
	  WinWaitActive("Fatal Error","Installation ended prematurely because of an error")
	  SLEEP(0x000001F4)
	  ControlClick("Fatal Error","Installation ended prematurely because of an error","Button1","left",1)
	  WinWaitClose("Fatal Error","Installation ended prematurely because of an error")
   Else
	  WinWaitActive("Cisco Systems VPN Client 5.0.07.0290 Setup","Welcome to the Cisco Systems VPN Client")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive("Cisco Systems VPN Client 5.0.07.0290 Setup","License Agreemen")
	  SLEEP(0x000001F4)
	  Send("!a")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive("Cisco Systems VPN Client 5.0.07.0290 Setup","Destination Folder")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive("Cisco Systems VPN Client 5.0.07.0290 Setup","Ready to Install the Application")
	  SLEEP(0x000001F4)
	  Send("!n")
	  SLEEP(0x000001F4)
	  WinWaitActive("Cisco Systems VPN Client 5.0.07.0290 Setup","successfully installed")
	  FileCopy($fileSrvPath & "\Cisco\Cisco.VPN.Client.v5.0.07.0290.x64\awesomit-IDC.pcf","C:\Program Files (x86)\Cisco Systems\VPN Client\Profiles",1)
	  SLEEP(0x000001F4)
	  ControlClick("Cisco Systems VPN Client 5.0.07.0290 Setup","successfully installed","Button1","left",1)
	  If WinExists("Installer Information") Then
		 WinActivate("Installer Information","You must restart your system")
		 WinWaitActive("Installer Information","You must restart your system")
		 SLEEP(0x000001F4)
		 ControlClick("Installer Information","You must restart your system","Button2","left",1)
		 WinWaitClose("Installer Information","You must restart your system")
	  Else
		 WinWaitClose("Cisco Systems VPN Client 5.0.07.0290 Setup","successfully installed")
	  EndIf
   EndIf

EndFunc

;;安装售后系统MinervaPro
Func _run25()

   WinMinimizeAll()

   If IsAdmin() Then
	  Run($fileSrvPath & "\Minerva Pro\MinervaProSetup02.exe")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,$fileSrvPath & "\Minerva Pro\MinervaProSetup02.exe","")
   EndIf
   WinWaitActive("Minerva Pro 2.0.3.19","Do you want to install the Minerva Pro 2.0.3.19 ?")
   SLEEP(0x000001F4)
   Send("!y")
   SLEEP(0x000001F4)
   WinWaitActive("Minerva Pro","欢迎使用 Minerva Pro 安装向导")
   $tempMinervaText = WinGetText("")
   If StringInStr($tempMinervaText,"选择是否要修复或移除") Then
	  SLEEP(0x000001F4)
	  ControlClick("Minerva Pro","选择是否要修复或移除 Minerva Pro","Button5","left",1)
	  WinWaitActive("Minerva Pro","尚未完成安装。确实要退出吗?")
	  SLEEP(0x000001F4)
	  Send("!y")
	  WinWaitActive("Minerva Pro","安装被中断")
	  SLEEP(0x000001F4)
	  Send("!c")
	  WinWaitClose("Minerva Pro","安装被中断")
   Else
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive("Minerva Pro","选择安装文件夹")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive("Minerva Pro","确认安装")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive("Minerva Pro","安装完成")
	  SLEEP(0x000001F4)
	  Send("!c")
	  WinWaitClose("Minerva Pro","安装完成")
	  FileCopy($fileSrvPath & "\Minerva Pro\WSProxy.cfg","C:\Program Files (x86)\Logimass Minerva Pro\Minerva Pro\MinervaPro",1)
	  SLEEP(0x000001F4)
   EndIf
   If IsAdmin() Then
	  Run("explorer C:\Program Files (x86)\Logimass Minerva Pro")
	  WinWaitActive("Logimass Minerva Pro","地址: C:\Program Files (x86)\Logimass Minerva Pro")
	  SLEEP(0x000001F4)
	  Send("{APPSKEY}")
	  SLEEP(0x000001F4)
	  Send("r")
	  WinWaitActive("Logimass Minerva Pro 属性","常规")
	  SLEEP(0x000001F4)
	  Send("^{TAB}")
	  SLEEP(0x000001F4)
	  Send("^{TAB}")
	  WinWaitActive("Logimass Minerva Pro 属性","安全")
	  SLEEP(0x000001F4)
	  Send("!e")
	  WinWaitActive("Logimass Minerva Pro 的权限","安全")
	  SLEEP(0x000001F4)
	  Send("!d")
	  WinWaitActive("选择用户、计算机、服务帐户或组","选择此对象类型(&S):")
	  SLEEP(0x000001F4)
	  ControlSetText("选择用户、计算机、服务帐户或组","选择此对象类型(&S):","RichEdit20W1","everyone")
	  SLEEP(0x000001F4)
	  Send("!c")
	  WinWaitActive("Windows 安全")
	  SLEEP(0x000001F4)
	  ControlSetText("Windows 安全","","Edit1",$itUserName)
	  SLEEP(0x000001F4)
	  ControlSetText("Windows 安全","","Edit2",$itPassword)
	  SLEEP(0x000001F4)
	  ControlClick("Windows 安全","","Button2","left",1)
	  WinWaitActive("选择用户、计算机、服务帐户或组","选择此对象类型(&S):")
	  SLEEP(0x000001F4)
	  ControlClick("选择用户、计算机、服务帐户或组","选择此对象类型(&S):","Button5","left",1)
	  WinWaitActive("Logimass Minerva Pro 的权限","安全")
	  SLEEP(0x000001F4)
	  ControlCommand("Logimass Minerva Pro 的权限","安全","Button4","Check","")
	  SLEEP(0x000001F4)
	  ControlClick("Logimass Minerva Pro 的权限","安全","Button21","left",1)
	  SLEEP(0x000001F4)
	  ControlClick("Logimass Minerva Pro 的权限","安全","Button19","left",1)
	  WinWaitActive("Logimass Minerva Pro 属性","安全")
	  SLEEP(0x000001F4)
	  ControlClick("Logimass Minerva Pro 属性","安全","Button13","left",1)
	  WinWaitActive("Logimass Minerva Pro","地址: C:\Program Files (x86)\Logimass Minerva Pro")
	  SLEEP(0x000001F4)
	  WinClose("Logimass Minerva Pro","地址: C:\Program Files (x86)\Logimass Minerva Pro")
	  WinWaitClose("Logimass Minerva Pro","地址: C:\Program Files (x86)\Logimass Minerva Pro")
   Else
	  MsgBox(64,"提示","当前用户无权操作目录权限，请切换本地管理员账户操作！",2)
   EndIf

EndFunc

;;安装Avaya软电话
Func _run26()

   WinMinimizeAll()

   If IsAdmin() Then
	  Run($fileSrvPath & "\Avaya\onexc_6.2.6.03\Avaya one-X Communicator Suite.exe")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,$fileSrvPath & "\Avaya\onexc_6.2.6.03\Avaya one-X Communicator Suite.exe","")
   EndIf
   WinWaitActive("Avaya one-X® Communicator InstallShield Wizard","中文 (简体)")
   Local $tempAvayaTitle = WinGetTitle("")
   SLEEP(0x000001F4)
   Send("!n")
   WinWaitActive($tempAvayaTitle)
   Local $tempAvayaText = WinGetText("")
   If StringInStr($tempAvayaText,"删除") Then
	  SLEEP(0x000001F4)
	  ControlClick($tempAvayaTitle,"删除","Button5","left",1)
	  WinWaitActive($tempAvayaTitle,"要取消 Avaya one-X® Communicator 安装吗")
	  SLEEP(0x000001F4)
	  Send("!y")
	  WinWaitActive($tempAvayaTitle,"InstallShield Wizard 完成")
	  SLEEP(0x000001F4)
	  Send("!f")
	  WinWaitClose($tempAvayaTitle,"InstallShield Wizard 完成")
   Else
	  SLEEP(0x000001F4)
	  WinWaitActive($tempAvayaTitle,"欢迎使用")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive($tempAvayaTitle,"请仔细阅读下面的许可证协议")
	  SLEEP(0x000001F4)
	  ControlCommand($tempAvayaTitle,"请仔细阅读下面的许可证协议","Button6","Check")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive($tempAvayaTitle,"自定义(&S)")
	  SLEEP(0x000001F4)
	  Send("s")
	  WinWaitActive($tempAvayaTitle,"选择要安装的程序功能")
	  SLEEP(0x000001F4)
	  Send("{DOWN}")
	  SLEEP(0x000001F4)
	  Send("{SPACE}")
	  SLEEP(0x000001F4)
	  Send("!n")
	  WinWaitActive($tempAvayaTitle,"注意：强烈建议大多数用户使用默认安装文件夹")
	  SLEEP(0x000001F4)
	  Send("!i")
	  WinWaitActive($tempAvayaTitle,"InstallShield Wizard 完成")
	  SLEEP(0x000001F4)
	  Send("!f")
	  WinWaitClose($tempAvayaTitle,"InstallShield Wizard 完成")
   EndIf

EndFunc

;;卸载TeamViewer11，安装TeamViewer10
Func _run27()

   WinMinimizeAll()

   ;;卸载TeamViewer11
   If ProcessExists("TeamViewer.exe") Then
	  ProcessClose("TeamViewer.exe")
   EndIf
   If IsAdmin() Then
	  Run($fileSrvPath & "\TeamViewer\TeamViewer10\卸载TeamViewer11.exe")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,$fileSrvPath & "\TeamViewer\TeamViewer10\卸载TeamViewer11.exe","")
   EndIf
   ;WinWaitActive("TeamViewer 11 Uninstall")
   WinWaitActive("")
   Local $tempTeamViewerTitle = WinGetTitle("")
   SLEEP(0x000001F4)
   ControlCommand($tempTeamViewerTitle,"","Button4","Check")
   SLEEP(0x000001F4)
   ControlClick($tempTeamViewerTitle,"","Button2","left",1)
   WinWait($tempTeamViewerTitle,"Uninstall was completed successfully")
   WinActivate($tempTeamViewerTitle,"Uninstall was completed successfully")
   WinWaitActive($tempTeamViewerTitle,"Uninstall was completed successfully")
   SLEEP(0x000001F4)
   ControlClick($tempTeamViewerTitle,"Uninstall was completed successfully","Button2","left",1)
   WinWaitClose($tempTeamViewerTitle,"Uninstall was completed successfully")
   SLEEP(0x000001F4)
   If WinExists("Internet Explorer 11","设置 Internet Explorer 11") Then
	  WinActivate("Internet Explorer 11","设置 Internet Explorer 11")
	  WinWaitActive("Internet Explorer 11","设置 Internet Explorer 11")
	  SLEEP(0x000001F4)
	  Send("!u")
	  SLEEP(0x000001F4)
	  ControlCommand("Internet Explorer 11","设置 Internet Explorer 11","Button5","Check")
	  SLEEP(0x000001F4)
	  Send("!o")
	  WinWaitActive("体验全新浏览器 — Microsoft Windows - Internet Explorer")
	  SLEEP(0x000001F4)
	  WinClose("体验全新浏览器 — Microsoft Windows - Internet Explorer")
	  WinWaitClose("体验全新浏览器 — Microsoft Windows - Internet Explorer")
   ElseIf WinExists("卸载反馈 - Internet Explorer") Then
	  WinActivate("卸载反馈 - Internet Explorer")
	  WinWaitActive("卸载反馈 - Internet Explorer")
	  SLEEP(0x000001F4)
	  WinClose("卸载反馈 - Internet Explorer")
	  WinWaitClose("卸载反馈 - Internet Explorer")
   EndIf
   SLEEP(0x000001F4)
   ;;安装TteamViewer10
   If IsAdmin() Then
	  Run($fileSrvPath & "\TeamViewer\TeamViewer10\安装TeamViewer10.exe")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,$fileSrvPath & "\TeamViewer\TeamViewer10\安装TeamViewer10.exe","")
   EndIf
   WinWaitActive("TeamViewer 10 安装")
   SLEEP(0x000001F4)
   ControlClick("TeamViewer 10 安装","","Button4","left",1)
   SLEEP(0x000001F4)
   ControlClick("TeamViewer 10 安装","","Button8","left",1)
   SLEEP(0x000001F4)
   ControlClick("TeamViewer 10 安装","","Button2","left",1)
   WinWait("TeamViewer","控制远程计算机")
   WinActivate("TeamViewer","控制远程计算机")
   WinWaitActive("TeamViewer","控制远程计算机")
   SLEEP(0x000001F4)
   WinClose("TeamViewer","控制远程计算机")
   WinWaitClose("TeamViewer","控制远程计算机")

EndFunc

;;安装TteamViewer10
Func _run28()

   WinMinimizeAll()

   If IsAdmin() Then
	  Run($fileSrvPath & "\TeamViewer\TeamViewer10\安装TeamViewer10.exe")
   Else
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,$fileSrvPath & "\TeamViewer\TeamViewer10\安装TeamViewer10.exe","")
   EndIf
   WinWaitActive("TeamViewer 10 安装")
   SLEEP(0x000001F4)
   ControlClick("TeamViewer 10 安装","","Button4","left",1)
   SLEEP(0x000001F4)
   ControlClick("TeamViewer 10 安装","","Button8","left",1)
   SLEEP(0x000001F4)
   ControlClick("TeamViewer 10 安装","","Button2","left",1)
   WinWait("TeamViewer","控制远程计算机")
   WinActivate("TeamViewer","控制远程计算机")
   WinWaitActive("TeamViewer","控制远程计算机")
   SLEEP(0x000001F4)
   WinClose("TeamViewer","控制远程计算机")
   WinWaitClose("TeamViewer","控制远程计算机")

EndFunc

;;预留
;;Func _run29()
;;Func _run30()
;;Func _run31()
;;Func _run32()
;;Func _run33()
;;Func _run34()
;;Func _run35()
;;Func _run36()
;;Func _run37()
;;Func _run38()
;;Func _run39()
;;Func _run40()

;;取消自动登录
Func _run41()

   SLEEP(0x000001F4)

   RegWrite("HKEY_LOCAL_MACHINE64\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AutoAdminLogon", "REG_SZ", "0")
   RegWrite("HKEY_LOCAL_MACHINE64\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultDomainName", "REG_SZ", ".")
   RegWrite("HKEY_LOCAL_MACHINE64\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultUserName", "REG_SZ", "administrator")
   RegDelete("HKEY_LOCAL_MACHINE64\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "Defaultpassword")

EndFunc

;;取消管理员权限
Func _run42()

   SLEEP(0x000001F4)

   Local $tempUserName = @UserName
   If IsAdmin() Then
	  Run("net localgroup /delete  administrators " & $domainName & "\" & $tempUserName)
   Else
	  ;MsgBox(64,"警告","当前用户无权操作本地管理员组！",2)
	  RunAs($rootUserName,@ComputerName,$rootPassword,0,"net localgroup /delete  administrators " & $domainName & "\" & $tempUserName,"")
   EndIf

EndFunc

;;销售用户配置
Func _run43()

   WinMinimizeAll()

   FileCopy("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Cisco Systems VPN Client\VPN Client.lnk", @UserProfileDir & "\Desktop",1)
   FileCopy("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook 2016.lnk", @UserProfileDir & "\Desktop",1)
   FileCopy("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Skype for Business 2016.lnk",@UserProfileDir & "\Desktop",1)

   _userConf()

EndFunc

;;运营用户配置
Func _run44()

   WinMinimizeAll()

   FileCopy("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Linphone 3.10.2\Linphone.lnk",@UserProfileDir & "\Desktop",1)
   FileCopy("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook 2016.lnk", @UserProfileDir & "\Desktop",1)
   FileCopy("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Skype for Business 2016.lnk",@UserProfileDir & "\Desktop",1)

   _userConf()

EndFunc

;;售后用户配置
Func _run45()

   WinMinimizeAll()

   FileCopy("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Logimass Minerva Pro\Minerva Pro.lnk", @UserProfileDir & "\Desktop",1)
   FileCopy("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Avaya\Avaya one-X Communicator .lnk",@UserProfileDir & "\Desktop",1)
   FileCopy("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook 2016.lnk", @UserProfileDir & "\Desktop",1)
   FileCopy("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Skype for Business 2016.lnk",@UserProfileDir & "\Desktop",1)

   _userConf()

EndFunc

;;预留
;;Func _run44()
;;Func _run45()
;;Func _run46()
;;Func _run47()
;;Func _run48()
;;Func _run49()
;;Func _run50()


;;自动重启并登录系统
func _run51()

   _autoLogin()

   _autoReboot()

EndFunc


; Script End