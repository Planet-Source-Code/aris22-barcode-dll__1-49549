Attribute VB_Name = "Code39"
Dim Code_A As String
Dim Code_B() As Variant

Dim BarH As Long
Dim zBarText As String
Dim xObj As Object

Dim xPos As Long, xtop As Long, zHasCaption As Boolean
Dim xStart As Integer, posCtr As Integer, xTotal As Long, chkSum As Long, WithCheckSum As Boolean
Private Const ChkChar = 43
Sub Bar39(zObj As Object, zBarH As Integer, BarText As String, Optional zWithCheckSum As Boolean = False, Optional ByVal HasCaption As Boolean = False)
   Set xObj = zObj
   WithCheckSum = zWithCheckSum
   Init_Table
   zBarText = BarText
   zHasCaption = HasCaption
   xObj.Picture = Nothing
   
   If Not CheckCode Then Exit Sub
   
   BarH = zBarH * 10
   xtop = 10
   
   xObj.BackColor = vbWhite
   xObj.AutoRedraw = True
   xObj.ScaleMode = 3
   
   If HasCaption Then
      xObj.Height = (xObj.TextHeight(zBarText) + BarH + 25) * Screen.TwipsPerPixelY
   Else
      xObj.Height = (BarH + 20) * Screen.TwipsPerPixelY
   End If
   'xObj.Height = (xObj.TextHeight(zBarText) + BarH + 25) * Screen.TwipsPerPixelY
   xObj.Width = (((Len(zBarText) + IIf(WithCheckSum, 3, 2)) * 12 + 20)) * 16
   
   'TEST
   Paint_Bar zBarText
   zObj.Picture = zObj.Image
End Sub
Function CheckCode() As Boolean
    Dim ii As Integer
    zBarText = UCase(Replace(zBarText, "*", ""))
    For ii = 1 To Len(zBarText)
        If InStr(Code_A, Mid(zBarText, ii, 1)) = 0 Then
           GoTo Err_Found
        End If
    Next
    CheckCode = True
    Exit Function
Err_Found:
    Err.Raise vbObjectError + 513, "Bar 39", _
      "An Invalid Character Found in Bar Text"
    CheckCode = False
End Function
Private Sub Paint_Bar(xstr As String)
    Dim ii As Long, jj As Integer, ctr As Integer
 
    xTotal = 0
    xPos = 1
    posCtr = 0
    
    Draw_Bar CStr(Code_B(ChkChar))
    
    For ii = 1 To Len(xstr)
        posCtr = InStr(Code_A, Mid(xstr, ii, 1)) - 1
        
        xTotal = xTotal + posCtr
        
        Draw_Bar CStr(Code_B(posCtr))
        
    Next
    chkSum = xTotal Mod 43
    
    If WithCheckSum Then Draw_Bar CStr(Code_B(chkSum))
    
    Draw_Bar CStr(Code_B(ChkChar))
    
    If zHasCaption Then
        xObj.CurrentX = ((xPos + 20) / 2) - xObj.TextWidth(xstr) / 2   ' Horizontal position.
        xObj.CurrentY = 15 + BarH    ' Vertical position.
        xObj.Print xstr   ' Print message.
    End If
End Sub
Private Sub Draw_Bar(Encoding As String)
    Dim ii As Integer
    For ii = 1 To Len(Encoding)
        xPos = xPos + 1
        xObj.Line (xPos + 10, xtop)-(xPos + 10, xtop + BarH), IIf(Mid(Encoding, ii, 1), vbBlack, vbWhite)
    Next
    xPos = xPos + 1
    xObj.Line (xPos + 10, xtop)-(xPos + 10, xtop + BarH), vbWhite
End Sub
Private Sub Init_Table()
    Code_A = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*"
    Code_B = Array( _
             "101001101101", "110100101011", "101100101011", "110110010101", "101001101011", "110100110101", _
             "101100110101", "101001011011", "110100101101", "101100101101", "110101001011", "101101001011", _
             "110110100101", "101011001011", "110101100101", "101101100101", "101010011011", "110101001101", _
             "101101001101", "101011001101", "110101010011", "101101010011", "110110101001", "101011010011", _
             "110101101001", "101101101001", "101010110011", "110101011001", "101101011001", "101011011001", _
             "110010101011", "100110101011", "110011010101", "100101101011", "110010110101", "100110110101", _
             "100101011011", "110010101101", "100110101101", "100100100101", "100100101001", "100101001001", _
             "101001001001", "100101101101" _
             )
End Sub






