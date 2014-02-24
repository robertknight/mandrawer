function fish_prompt
	set job_list (jobs -c)
	set pwd_section (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
	if [ (count $job_list) -gt 0 ]
		set job_section "($job_list)"
	end
	printf '%s%s> ' "$pwd_section" "$job_section"
end
