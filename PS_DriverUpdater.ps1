#============[Initialize]====================

#Activate PowerShell GUI
Add-Type -assembly System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Get-DeviceList {
    $devices = Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, HardwareID
    $deviceList = New-Object System.Collections.SortedList
    foreach ($device in $devices) {
        $deviceList.Add($device.DeviceName, $device.HardwareID)
    }
    return $deviceList
}

#============[Form]====================

#Create new form
$DriverUpdaterForm = New-Object System.Windows.Forms.Form

#Define size, title, background color
$DriverUpdaterForm.ClientSize = '600,625'
$DriverUpdaterForm.AutoSize = $true
$DriverUpdaterForm.text = "PowerShell Driver Updater - Use with Driver Easy"
$DriverUpdaterForm.BackColor = "#D9D9D9"

#==================[Accordion + Contents]================================
$accordion = New-Object System.Windows.Forms.GroupBox
$accordion.Location = New-Object System.Drawing.Point(20, 85)
$accordion.AutoSize = $true
$accordion.Visible = $false

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.AutoSize = $true
$listBox.Font = 'Microsoft Sans Serif, 14'
$listBox.Items.Add("1. Open Driver Easy")
$listBox.Items.Add("2. Press 'Scan Now' button")
$listBox.Items.Add("3. Find driver you want to update.")
$listBox.Items.Add("    3a. If multiple drivers have the same name, click the arrow next to 'Update'")
$listBox.Items.Add("    3b. Click 'View driver details' in the dropdown menu.")
$listBox.Items.Add("    3c. Scroll down to 'Compatibility.")
$listBox.Items.Add("    3d. If necessary, right click each Hardware ID and paste into a document for future reference.")
$listBox.Items.Add("4. Press 'Update' button.")
$listBox.Items.Add("5. Wait for download to complete.")
$listBox.Items.Add("6. Click 'Manual Install.'")
$listBox.Items.Add("7. In the new window with the driver folder, right click the address bar, and click 'Copy Address as Text.'")
$listBox.Items.Add("8. Paste address in text box in the app.")
$listBox.Items.Add("9. Press 'Update Driver' button.")
$listBox.Items.Add("10. After updating all drivers, press 'Clean Driver Easy Folder' to clean up downloaded driver files.")
$listBox.Dock = "Fill"

$accordion.Controls.Add($listBox)

$InstructionBtn = New-Object System.Windows.Forms.Button
$InstructionBtn.Location = New-Object System.Drawing.Point(185, 10)
#$InstructionBtn.Size = New-Object System.Drawing.Size(75,23)
$InstructionBtn.AutoSize = $true
$InstructionBtn.BackColor = "#545454"
$InstructionBtn.ForeColor = "#ffffff"
$InstructionBtn.Font = 'Microsoft Sans Serif, 32,style=Bold'
$InstructionBtn.Text = "Instructions"
$InstructionBtn.Add_Click({
    $accordion.Visible = !$accordion.Visible
    $InstructionBtn.BringToFront()
})
#========================================================================

#===========================[Dropdown label]=============================

$DropDownLabel                = New-Object system.Windows.Forms.Label
$DropDownLabel.text           = "Driver Name and Hardware ID:"
$DropDownLabel.AutoSize       = $true
$DropDownLabel.width          = 185
$DropDownLabel.height         = 20
$DropDownLabel.location       = New-Object System.Drawing.Point(30,102)
$DropDownLabel.Font           = 'Microsoft Sans Serif,10,style=Bold'
$DropDownLabel.Visible        = $true

#========================================================================

#===========================[Dropdown list]==============================
$DriverDropdown = New-Object System.Windows.Forms.ComboBox
$DriverDropdown.text = ""
$DriverDropdown.width = 540
$DriverDropdown.AutoSize = $true

#Add items in dropdown list
$devices = Get-DeviceList | Sort-Object Key -Descending
foreach ($device in $devices.GetEnumerator()) {
    $DriverDropdown.Items.Add($device.Key + " - " + $device.Value)
}

# Select the default value
$DriverDropdown.SelectedIndex = 0
$DriverDropdown.Location = New-Object System.Drawing.Point(30,125)
$DriverDropdown.Font = 'Microsoft Sans Serif, 14'

#=========================================================================

#===============================[Text Box label]==========================
$TextBoxLabel                = New-Object system.Windows.Forms.Label
$TextBoxLabel.text           = "Driver Update Directory:"
$TextBoxLabel.AutoSize       = $true
$TextBoxLabel.width          = 25
$TextBoxLabel.height         = 20
$TextBoxLabel.location       = New-Object System.Drawing.Point(30,163)
$TextBoxLabel.Font           = 'Microsoft Sans Serif,10,style=Bold'
$TextBoxLabel.Visible        = $true
#========================================================================

#=========================[Folder Location Text Box]=====================

$TextBox                     = New-Object system.Windows.Forms.TextBox
$TextBox.multiline           = $false
$TextBox.width               = 540
$TextBox.height              = 20
$TextBox.location            = New-Object System.Drawing.Point(30,186)
$TextBox.Font                = 'Microsoft Sans Serif,10'
$TextBox.Visible             = $true

#========================================================================

#=========================[Update Driver button]=========================
$UpdateDriverBtn = New-Object system.Windows.Forms.Button
$UpdateDriverBtn.BackColor = "#545454"
$UpdateDriverBtn.text = "Update Driver"
$UpdateDriverBtn.AutoSize = $true
$UpdateDriverBtn.location = New-Object System.Drawing.Point(212,219)
$UpdateDriverBtn.Font = 'Microsoft Sans Serif,20'
$UpdateDriverBtn.ForeColor = "#ffffff"
$UpdateDriverBtn.Visible = $true
#========================================================================

#=========================[Driver List button]=========================
$DriverListBtn = New-Object system.Windows.Forms.Button
$DriverListBtn.BackColor = "#545454"
$DriverListBtn.text = "Generate Driver List"
#$DriverListBtn.AutoSize = $true
$DriverListBtn.Width = 177
$DriverListBtn.Height = 57
$DriverListBtn.location = New-Object System.Drawing.Point(5,318)
$DriverListBtn.Font = 'Microsoft Sans Serif,14'
$DriverListBtn.ForeColor = "#ffffff"
$DriverListBtn.Visible = $true


$tooltip01 = New-Object System.Windows.Forms.ToolTip
$tooltip01.SetToolTip($DriverListBtn, "Saves list of driver data to Documents folder.")
#========================================================================

#=========================[Open Driver Easy Folder button]=========================
$DriverFolderOpenBtn = New-Object system.Windows.Forms.Button
$DriverFolderOpenBtn.BackColor = "#545454"
$DriverFolderOpenBtn.text = "Open Driver Easy Folder"
#$DriverFolderOpenBtn.AutoSize = $true
$DriverFolderOpenBtn.Width = 205
$DriverFolderOpenBtn.Height = 57
$DriverFolderOpenBtn.location = New-Object System.Drawing.Point(182,318)
$DriverFolderOpenBtn.Font = 'Microsoft Sans Serif,14'
$DriverFolderOpenBtn.ForeColor = "#ffffff"
$DriverFolderOpenBtn.Visible = $true

$tooltip02 = New-Object System.Windows.Forms.ToolTip
$tooltip02.SetToolTip($DriverFolderOpenBtn, "Opens temporary driver download folder.")
#========================================================================

#=========================[Clean Driver Easy Folder button]=========================
$DriverFolderCleanBtn = New-Object system.Windows.Forms.Button
$DriverFolderCleanBtn.BackColor = "#545454"
$DriverFolderCleanBtn.text = "Clean Driver Easy Folder"
#$DriverFolderCleanBtn.AutoSize = $true
$DriverFolderCleanBtn.Width = 207
$DriverFolderCleanBtn.Height = 57
$DriverFolderCleanBtn.location = New-Object System.Drawing.Point(387,318)
$DriverFolderCleanBtn.Font = 'Microsoft Sans Serif,14'
$DriverFolderCleanBtn.ForeColor = "#ffffff"
$DriverFolderCleanBtn.Visible = $true

$tooltip03 = New-Object System.Windows.Forms.ToolTip
$tooltip03.SetToolTip($DriverFolderCleanBtn, "Erase downloaded driver files.")
#========================================================================

#=======================[App Info Label]=================================
$AppInfoLabel = New-Object System.Windows.Forms.Label
$AppInfoLabel.Location = New-Object System.Drawing.Point(30, 517)
$AppInfoLabel.AutoSize = $true
$AppInfoLabel.Text = "App Information:`nv 1.0 - 07.##.2023`nURL: https://github.com/korgano/PowerShellDriverUpdater`nDefault save: Documents"
$AppInfoLabel.Font = 'Microsoft Sans Serif,14'
$AppInfoLabel.Visible = $true
#========================================================================

#$DriverUpdaterForm.Controls.Add($accordion)
#$DriverUpdaterForm.Controls.Add($InstructionBtn)
#$DriverUpdaterForm.Controls.Add($DropDownLabel)
#$DriverUpdaterForm.Controls.Add($DriverDropdown)
#$DriverUpdaterForm.Controls.Add($TextBoxLabel)
#$DriverUpdaterForm.Controls.Add($TextBox)
#$DriverUpdaterForm.Controls.Add($UpdateDriverBtn)
#$DriverUpdaterForm.Controls.Add($DriverListBtn)
#$DriverUpdaterForm.Controls.Add($DriverFolderOpenBtn)
#$DriverUpdaterForm.Controls.Add($DriverFolderCleanBtn)
#$DriverUpdaterForm.Controls.Add($AppInfoLabel)
$DriverUpdaterForm.controls.AddRange(@($accordion,$InstructionBtn,$DropDownLabel,$DriverDropdown,$TextBoxLabel),$TextBox,$UpdateDriverBtn,$DriverListBtn,$DriverFolderOpenBtn,$DriverFolderCleanBtn,$AppInfoLabel))


#Display form
[void]$DriverUpdaterForm.ShowDialog()



#===============[Functions]===============

#function Get-DeviceList {
#    $devices = Get-WmiObject Win32_PnPSignedDriver | Select-Object DeviceName, HardwareID
#    $deviceList = @{}
#    foreach ($device in $devices) {
#        $deviceList.Add($device.DeviceName, $device.HardwareID)
#    }
#    return $deviceList
#}


#===============[Script]==================

#=======================[]===============================




#=======================================================================

#===============[Show Form]===================