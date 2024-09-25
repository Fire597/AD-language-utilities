# Definition of some variables
$regex = "^S-1-5-21-\d{10}-\d{10}-\d{10}-512$" #refers to unique known SID for domain admins 
$Groups = Get-ADGroup -Filter *
$RID512 = ""

# Get-Group allows to get group depending on language
function Get-Group{
param(
    $GroupeType,
    $lang
)

    if ($GroupeType -eq "DomainAdmins")
    {
        $result=$RID512.Name
    }
    elseif ("EnterpriseAdmins") {
        switch ($lang) {
            "en" { $result = "Enterprise Admins" }
            "fr" { $result = "Admins de l'entreprise" }
            "de" { $result = "Organisations-Admins" }
            Default {$result = "Enterprise Admins"}
        }
    }
    elseif ("DomainUsers") {
        switch ($lang) {
            #"en" { $result = "Enterprise Admins" }
            "fr" { $result = "Utilisateurs du domaine" }
            #"de" { $result = "Organisations-Admins" }
            Default {$result = "DomainUsers"}
        }
    }

    return $result
}

# Begin script
# Get Domain Admins group

foreach ($Group in $Groups)
{
    if ($Group.sid -match $regex)
    {
        $RID512 = $Group
        break
    }
}

# Determine language depending on group name
switch ($RID512.Name) {
    "Admins du domaine" {$language="fr"}
    "Administrator" {$language="en"}
    "Domänen-Admins" {$language="de"}
    Default {$language="en"}
}

# Examples of known group you may retrieve
$DomainAdminGroup = Get-Group("DomainAdmins",$language)
$EnterpriseAdminGroup = Get-Group("EnterpriseAdmins",$language)
$DomainUsers = Get-Group("DomainUsers",$language)