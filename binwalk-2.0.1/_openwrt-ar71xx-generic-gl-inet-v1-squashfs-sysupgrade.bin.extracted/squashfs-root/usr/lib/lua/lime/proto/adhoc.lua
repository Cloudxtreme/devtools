#!/usr/bin/lua

local adhoc_mode = require("lime.mode.adhoc")

local adhoc = {}

adhoc.configured = false

function adhoc.configure(args)
	adhoc.configured = true
end

function adhoc.setup_interface(ifname, args)
	if ifname:match("^wlan%d+_"..adhoc_mode.wifi_mode) then
		local libuci = require "uci"
		local uci = libuci:cursor()

		local networkInterfaceName = network.limeIfNamePrefix..ifname

		uci:set("network", networkInterfaceName, "interface")
		uci:set("network", networkInterfaceName, "proto", "none")
		uci:set("network", networkInterfaceName, "mtu", "1536")
		uci:set("network", networkInterfaceName, "auto", "1")

		uci:save("network")
	end
end

return adhoc
