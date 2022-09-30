$GroupName = "Administratoren"
$GoodList = '' #Administrator','Domain\Administrator','Domain\Domänen-Adminis oder von Liste '\\domain.de\dfs\data\Script\userlist.txt'
$GoodAdmins = Get-Content $Goodlist
        
Get-LocalGroupMember $GroupName |
    ForEach-Object{
        if ($_.ObjectClass -eq 'Benutzer'){
            if ($GoodAdmins -contains $_.Name){     # ignore groups in the administrators group
                                                    # the user's on the approved list, move on
            }
            else{
                Remove-LocalGroupMember -Group $GroupName -Member $_.Name 
            }
        }
    }