# openwrt feed

# TR-069/CWMP 设备客户端程序
`lcwmpd` 是的[TR-069/CWMP](https://cwmp-data-models.broadband-forum.org/)协议客户端实现。

它是用C编程语言编写的，依赖于许多OpenWrt库来构建和运行。

## 客户端特性
* 经过通用ACS测试， 例如： **Axiros**, **AVSytem**, **GenieACS**, **OpenACS**, 等等...
* 支持所有必需的 **TR069 RPCs**.
* 支持TR系列的所有数据模型，例如： **TR-181**, **TR-104**, **TR-143**, **TR-157**, 等等...
* 支持所有类型的连接请求，例如： **HTTP**, **XMPP**, **STUN**.
* 支持集成文件传输，例如 **HTTP**, **HTTPS**, **FTP**.

# TR-369/USP守护进程（uspd）

`uspd` 是数据模型守护进程，根据需要通过UBU公开数据模型对象
由[TR-069/cwmp](https://cwmp-data-models.broadband-forum.org/) 或 [TR-369/USP](https://usp.technology/),
`uspd` 还支持[USP语法](https://usp.technology/specification/architecture/)如R-ARC.7 - R-ARC.12中所定义，并提供数据模型查询的详细信息。

> 提示1: 本自述中显示的命令输出仅为示例，实际输出可能因设备和配置而异。

> 提示2: 长命令输出被压缩以提高可读性

# TR-111/STUNC

NAT会话遍历实用程序（STUN）是一套标准化的方法，用于到达连接在NAT后面的CPE设备。CWMP协议引入了基于STUN通过NAT执行连接请求的替代方法。stunc是执行此功能的STUN客户端功能的实现。

# BBF datamodel（BBFDM）
`bbfdm`是一个数据模型库实现，包括一系列对象、参数和操作，用于通过远程控制协议进行CPE管理,例如[TR-069/CWMP](https://cwmp-data-models.broadband-forum.org/) 和 [TR-369/USP](https://usp.technology/).
