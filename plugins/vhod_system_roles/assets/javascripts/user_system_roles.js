old_window_onload = window.onload;
window.onload = function(){
    if(old_window_onload){
        old_window_onload();
    }

    jQuery("#user_auth_source_id").change(function(){
        if(this.value){
            jQuery("#user_system_roles_fields").hide();
        }
        else{
            jQuery("#user_system_roles_fields").show();
        }
    });
}
