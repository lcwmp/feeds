#!/bin/sh

log() {
	echo "$@" |logger -t cwmp.update -p info
}

handle_icwmp_update() {
	local defwan vendorspecinf update
	local bootup_start

	bootup_start="${1:-0}"
	update="0"
	defwan="$(uci -q get cwmp.cpe.default_wan_interface)"
	vendorspecinf="$(ifstatus "${defwan}" | jsonfilter -e "@.data.vendorspecinf")"

	log "Handling dhcp option value [${vendorspecinf}]"
	[ -n "$vendorspecinf" ] && {
		local url old_url
		local prov_code old_prov_code
		local min_wait_interval old_min_wait_interval
		local retry_interval_multiplier old_retry_interval_multiplier

		old_url="$(uci -q get cwmp.acs.dhcp_url)"
		old_prov_code="$(uci -q get cwmp.cpe.dhcp_provisioning_code)"
		old_min_wait_interval="$(uci -q get cwmp.acs.dhcp_retry_min_wait_interval)"
		old_retry_interval_multiplier="$(uci -q get cwmp.acs.dhcp_retry_interval_multiplier)"

		case $vendorspecinf in
			http://*|https://*)
					url="${vendorspecinf}"
				;;
			*)
				for optval in $vendorspecinf; do
				        case $optval in
				                1=*)
				                        url="$(echo "$optval" | cut -d"=" -f2-)"
				                ;;
				                2=*)
				                        prov_code="$(echo "$optval" | cut -d"=" -f2-)"
				                ;;
				                3=*)
				                        min_wait_interval="$(echo "$optval" | cut -d"=" -f2-)"
				                ;;
				                4=*)
				                        retry_interval_multiplier="$(echo "$optval" | cut -d"=" -f2-)"
				                ;;
				        esac
				done
			;;
		esac

		if [ -n "$url" ]; then
			if [ "${url}" != "${old_url}" ]; then
				log "## icwmp url[${old_url}] changed to [${url}]"
				uci -q set cwmp.acs.dhcp_url="$url"
				update=1
			fi
		fi
		if [ -n "$prov_code" ]; then
			if [ "${prov_code}" != "${old_prov_code}" ]; then
				log "## icwmp prov_code[${old_prov_code}] changed to [${prov_code}]"
				uci -q set cwmp.cpe.dhcp_provisioning_code="$prov_code"
				update=1
			fi
		fi
		if [ -n "$min_wait_interval" ]; then
			if [ "${min_wait_interval}" != "${old_min_wait_interval}" ]; then
				log "## icwmp min_wait_interval[${old_min_wait_interval}] changed to [${min_wait_interval}]"
				uci -q set cwmp.acs.dhcp_retry_min_wait_interval="$min_wait_interval"
				update=1
			fi
		fi
		if [ -n "$retry_interval_multiplier" ]; then
			if [ "${retry_interval_multiplier}" != "${old_retry_interval_multiplier}" ]; then
				log "## icwmp retry_interval_multiplier[${old_retry_interval_multiplier}] changed to [${retry_interval_multiplier}]"
				uci -q set cwmp.acs.dhcp_retry_interval_multiplier="$retry_interval_multiplier"
				update=1
			fi
		fi
	}

	if [ "${bootup_start}" -eq "1" ]; then
		# if called at boot up then no need to reload the service, since it will start after
		uci commit cwmp
		return 0
	fi

	# In case of update restart icwmp
	if [ "${update}" -eq "1" ]; then
		log "CWMP uci changes, reload cwmp with uci commit"
		ubus call uci commit '{"config":"cwmp"}'
	else
		status="$(ubus call tr069 status |jsonfilter -qe '@.last_session.status')"
		if [ "$status" = "failure" ] || [ "$status" = "" ]; then
			log "Trigger out of bound inform, since last inform status was failure"
			ubus -t 10 call tr069 inform >/dev/null 2>&1
			# Handle timeout or tr069 object not found
			if [ "$?" -eq 7 ] || [ "$?" -eq 4 ]; then
				log "Restarting icwmp tr069 object"
				/etc/init.d/icwmpd restart
			fi
		fi
	fi
}

handle_icwmp_update $@
