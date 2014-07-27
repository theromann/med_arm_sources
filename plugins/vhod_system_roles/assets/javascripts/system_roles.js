
function modifyFormForThisRoleType(){
    var role_name = jQuery("#role_name")[0].value;
    if(jQuery("#role_type")[0].value == "SystemRole"){
        jQuery("#group_select").show();
        jQuery.get('/system_permissions?name=' + role_name).success(function(response){
            jQuery("#permissions").prepend(response);
        });
    }
    else{
        jQuery("#group_select").hide();
        jQuery("#groups")[0].selectedIndex = jQuery("#groups")[0].length + 1;
        jQuery("#system_permissions").remove();
    }
}