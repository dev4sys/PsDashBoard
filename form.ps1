#########################################################################
# Author:  Kevin RAHETILAHY                                             #   
# Blog: dev4sys.blogspot.fr                                             #
#########################################################################

#########################################################################
#                        Add shared_assemblies                          #
#########################################################################


[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null

[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')      | out-null  
[System.Reflection.Assembly]::LoadFrom('assembly\LiveCharts.dll')        | out-null  	
[System.Reflection.Assembly]::LoadFrom('assembly\LiveCharts.Wpf.dll') 	 | out-null  	


#########################################################################
#                        Load Main Panel                                #
#########################################################################

$Global:pathPanel= split-path -parent $MyInvocation.MyCommand.Definition


function LoadXaml ($filename){
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}


$XamlMainWindow=LoadXaml($pathPanel+"\form.xaml")
$reader = (New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form = [Windows.Markup.XamlReader]::Load($reader)


#########################################################################
#                        HAMBURGER VIEWS                                #
#########################################################################

#******************* Target View  *****************

$HamburgerMenuControl = $Form.FindName("HamburgerMenuControl")

$UserView      = $Form.FindName("UserView") 
$ComputerView  = $Form.FindName("ComputerView")
$AnalyticsView = $Form.FindName("AnalyticsView") 

#******************* Load Other Views  *****************
$viewFolder = $pathPanel +"\views"

$XamlChildWindow = LoadXaml($viewFolder+"\User.xaml")
$Childreader     = (New-Object System.Xml.XmlNodeReader $XamlChildWindow)
$UserXaml        = [Windows.Markup.XamlReader]::Load($Childreader)


$XamlChildWindow = LoadXaml($viewFolder+"\Computer.xaml")
$Childreader     = (New-Object System.Xml.XmlNodeReader $XamlChildWindow)
$ComputerXaml     = [Windows.Markup.XamlReader]::Load($Childreader)


$XamlChildWindow = LoadXaml($viewFolder+"\Analytics.xaml")
$Childreader     = (New-Object System.Xml.XmlNodeReader $XamlChildWindow)
$AnalyticsXaml    = [Windows.Markup.XamlReader]::Load($Childreader)
    
$UserView.Children.Add($UserXaml)          | Out-Null
$ComputerView.Children.Add($ComputerXaml)  | Out-Null    
$AnalyticsView.Children.Add($AnalyticsXaml)    | Out-Null      


#******************************************************
# Initialize with the first value of Item Section *****
#******************************************************

$HamburgerMenuControl.SelectedItem = $HamburgerMenuControl.ItemsSource[0]

$Doughnut     = $AnalyticsXaml.FindName("Doughnut")
$gridComputer = $ComputerXaml.FindName("gridComputer")


##############################################################
#                Doughnut                                    #
##############################################################
."$pathPanel\scripts\analytics.ps1"  
$Doughnut.Series = $DoughnutCollection

##############################################################
#                Computer                                    #
##############################################################
."$pathPanel\scripts\computer.ps1"  
$gridComputer.ItemsSource = $observableCollection

#########################################################################
#                        HAMBURGER EVENTS                               #
#########################################################################

#******************* Items Section  *******************

$HamburgerMenuControl.add_ItemClick({
    
   $HamburgerMenuControl.Content = $HamburgerMenuControl.SelectedItem
   $HamburgerMenuControl.IsPaneOpen = $false

})





#########################################################################
#                        Show Dialog                                    #
#########################################################################




$Form.ShowDialog() | Out-Null
  
