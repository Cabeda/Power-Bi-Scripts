
Login-PowerBIServiceAccount

$email = "powerbi.inovretail.com"
$groupId =""
$accessRights = "Admin" # Member, Admin, Contributor


Add-PowerBIWorkspaceUser -Id $groupId -UserEmailAddress $email -AccessRight $accessRights


