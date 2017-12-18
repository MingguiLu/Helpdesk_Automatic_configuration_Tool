# Helpdesk_Automation_Tool
A helpdesk automation tool developed with BASIC-like scripting

#### 关于Helpdesk_Automation_Tool

Helpdesk_Automation_Tool是由类BASIC语言的AutoIt v3 脚本编写，用于简化Helpdesk大量繁复的操作，通过GUI交互，实现自动设置系统选项、自动安装软件、自动重启电脑并登录域账户、自动复制桌面快捷方式、自动配置outlook及skype等

#### 配置说明

以下代码位于134 ~ 144行，`user-defined`部分请根据实际需求和场景自定义

	Global $rootUserName = "administrator" ;本地管理员administrator
	Global $rootPassword = "user-defined"  ;本地管理员密码
	
	Global $createUserName = "admin"  ;创建本地用户名
	Global $createUserPassword = "user-defined" ;设置本地用户名密码
	
	Global $domainName = "user-defined" ;AD域名，
	Global $itUserName = "user-defined" ;域账户
	Global $itPassword = "user-defined" ;域账户密码
	
	Global $fileSrvPath = "user-defined" ;安装文件所在的共享目录地址
	
	Global $userName	 ;用户域账号
	Global $userPassword ;用户域账户密码
	Global $hostName     ;用户计算机名

#### 注意事项

`自动重启系统+登录账户` 通过授予用户本地管理员权限并修改注册表实现，在系统重启自动登录用户账户后，需运行`取消自动登录` 和 `取消管理员权限`来重置注册表并从administrators组移出用户账户