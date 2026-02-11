$file = "c:\Users\bryan\Programas\Bitacora digital\bitacora_global\lib\pages\bit_complet\bit_complet_widget.dart"
$lines = Get-Content $file
$newLines = @()
$replacement = "                                                        Container(width: 55.0, height: 55.0, decoration: BoxDecoration(color: Color(0xFF293038), borderRadius: BorderRadius.circular(10.0)), child: Icon(Icons.person, color: Colors.white, size: 30)),"

for ($i = 0; $i -lt $lines.Count; $i++) {
    # Block Apertura (448-543 => Index 447-542)
    if ($i -ge 447 -and $i -le 542) {
        if ($i -eq 447) {
            $newLines += $replacement
        }
        continue
    }
    # Block Cierre (2530-2684 => Index 2529-2683)
    if ($i -ge 2529 -and $i -le 2683) {
        if ($i -eq 2529) {
            $newLines += $replacement
        }
        continue
    }
    $newLines += $lines[$i]
}

$newLines | Set-Content $file -Encoding UTF8
Write-Host "Done"
