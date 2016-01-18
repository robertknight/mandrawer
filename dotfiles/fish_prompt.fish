function fish_prompt
	set job_list (jobs -c)
	set pwd_section (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
	if [ (count $job_list) -gt 0 ]
		set job_section "($job_list)"
	end
	if set -q VIRTUAL_ENV
		echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal) " "
	end
	printf '%s%s> ' "$pwd_section" "$job_section"
end
