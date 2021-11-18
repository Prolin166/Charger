$regfile "m32def.dat"
$crystal = 4000000
$baud = 9600
$hwstack = 100
$swstack = 100
$framesize = 100

Config Sda = Portc.1
Config Scl = Portc.0
Config Pina.6 = Input
Config Pind.2 = Input
Config Portd.7 = Output
Config Portd.6 = Output
Config Portd.5 = Output
Config Portd.4 = Output
Config Portd.3 = Output
Config Porta.7 = Output
Config Portc.3 = Output
Config Portc.2 = Output
Config Portb.2 = Output
Config Portb.3 = Output
Config Portb.4 = Output

Config Lcdpin = Pin , Db4 = Portc.7 , Db5 = Portc.4 , Db6 = Portc.5 , Db7 = Portc.6 , E = Portb.0 , Rs = Portb.1
Config Lcd = 20 * 4
Cursor Off

Config Adc = Single , Prescaler = Auto , Reference = Internal
Config Serialout1 = Buffered

Dim Mv1 As Word
Dim Mv2 As Word
Dim Mv3 As Word
Dim Smv1 As Word
Dim Smv2 As Word
Dim Smv3 As Word
Dim Count As Word
Dim Count1 As Word
Dim Erg_v1 As Single
Dim Erg_v2 As Single
Dim Erg_v3 As Single
Dim Mc1 As Word
Dim Mc2 As Word
Dim Mc3 As Word
Dim Smc1 As Word
Dim Smc2 As Word
Dim Smc3 As Word
Dim Count_x As Word
Dim Erg_c1 As Single
Dim Erg_c2 As Single
Dim Erg_c3 As Single
Dim Buffer_y_n As Byte
Dim _weekday As Byte
Dim _day As Byte
Dim _month As Byte
Dim _year As Byte
Dim _sec As Byte
Dim _min As Byte
Dim _hour As Byte
Dim Ds1307w As Byte
Dim Ds1307r As Byte
Dim A1 As Integer
Dim A2 As Integer
Dim A3 As Integer
Dim Wait_ms As Word
Dim Round_v1 As String * 10
Dim Round_v2 As String * 10
Dim Round_v3 As String * 10
Dim Bcontent As String * 255
Dim Datumzeit As String * 255
Dim L1 As Byte
Dim L2 As Byte
Dim L3 As Byte
Dim Isset As Integer

Declare Sub Get_akku
Declare Sub Get_voltage
Declare Sub Get_current
Declare Sub Datetime
Declare Sub Settime
Declare Sub Setdate
Declare Sub Erhaltungsladung
Declare Sub Normalladung
Declare Sub Messen
Declare Sub Zwangsladung




Ds1307w = &B11010000
Ds1307r = &B11010001

Portd.7 = 1
Portd.6 = 1
Portd.5 = 1
Portd.4 = 1
Portd.3 = 1
Porta.7 = 1
Portc.3 = 1
Portc.2 = 1

Initlcd
Cursor Off

Cls
Locate 3 , 6
Lcd "Willkommen"
Portb.3 = 1
Waitms 1000
Portb.3 = 0
Portb.2 = 1
Waitms 1000
Portb.2 = 0
Portb.4 = 1
Waitms 1000
Portb.4 = 0
Waitms 1000
Call Datetime


Do
   Cls
   Locate 2 , 7
   Lcd "Warte..."
   Call Datetime
   Begin:
   Portd.7 = 1
   Portd.6 = 1
   Portd.5 = 1
   Portd.4 = 1
   Portd.3 = 1
   Portc.2 = 1
      If Pind.2 = 1 Then
         Call Messen
      End If
      If Pina.6 = 1 And Pind.2 = 0 Then
         Call Erhaltungsladung
      End If
      If Pina.6 = 0 And Pind.2 = 0 Then
         Call Normalladung
      End If
Loop
Messen:
Portd.3 = 1
Portd.4 = 1
Portd.5 = 1
Porta.7 = 1
Portc.2 = 1
Portb.4 = 1
Portb.3 = 0
Portb.2 = 0
Portd.6 = 1
Portd.7 = 1
Cls
Wait 1
Initlcd
Wait 1
Cls
Locate 1 , 1
Lcd "Ueberwachung"
Call Get_akku
   If A1 = 0 Then
      Locate 2 , 1
      Lcd "A1: ---   "
   End If
   If A2 = 0 Then
      Locate 3 , 1
      Lcd "A2: ---   "
   End If
   If A3 = 0 Then
      Locate 4 , 1
      Lcd "A3: ---   "
   End If
Call Get_voltage
      If A1 = 1 Then
         Locate 2 , 1
         Lcd "A1: " ; Round_v1 ; " V   "
      End If
      If A2 = 1 Then
         Locate 3 , 1
         Lcd "A2: " ; Round_v2 ; " V   "
      End If
      If A3 = 1 Then
         Locate 4 , 1
      Lcd "A3: " ; Round_v3 ; " V   "
      End If
Do
Call Datetime
   Portd.3 = 1
   Portd.4 = 1
   Portd.5 = 1
   Porta.7 = 1
   Portc.2 = 1
   Portb.4 = 1
   Portb.3 = 0
   Portb.2 = 0
   Call Get_akku
      If A1 = 0 Then
         Locate 2 , 1
         Lcd "A1: ---   "
      End If
      If A2 = 0 Then
         Locate 3 , 1
         Lcd "A2: ---   "
      End If
      If A3 = 0 Then
         Locate 4 , 1
         Lcd "A3: ---   "
      End If
   Call Get_voltage
         If A1 = 1 Then
            Locate 2 , 1
            Lcd "A1: " ; Round_v1 ; " V   "
         End If
         If A2 = 1 Then
            Locate 3 , 1
            Lcd "A2: " ; Round_v2 ; " V   "
         End If
         If A3 = 1 Then
            Locate 4 , 1
         Lcd "A3: " ; Round_v3 ; " V   "
         End If
      If Pind.2 = 0 Then
         Goto Begin
      End If
Loop
Return


Erhaltungsladung:
Portb.4 = 0
Portb.3 = 1
Portb.2 = 0
Porta.7 = 1
Portd.3 = 1
Portd.4 = 1
Portd.5 = 1
Portc.2 = 1
Portd.6 = 1
Portd.7 = 1
Cls
Locate 1 , 1
Lcd "Erhaltung"
Call Get_akku
   If A1 = 0 Then
      Locate 2 , 1
      Lcd "A1: ---   "
   End If
   If A2 = 0 Then
      Locate 3 , 1
      Lcd "A2: ---   "
   End If
   If A3 = 0 Then
      Locate 4 , 1
      Lcd "A3: ---   "
   End If
Call Get_voltage
      If A1 = 1 Then
         Locate 2 , 1
         Lcd "A1: " ; Round_v1 ; " V   "
      End If
      If A2 = 1 Then
         Locate 3 , 1
         Lcd "A2: " ; Round_v2 ; " V   "
      End If
      If A3 = 1 Then
         Locate 4 , 1
         Lcd "A3: " ; Round_v3 ; " V   "
      End If
   L1 = 0
   L2 = 0
   L3 = 0
Do
Call Datetime
      If A1 = 1 Then
      If Smv1 > 981 Then
         Portd.3 = 1
      Else
         Portd.3 = 0
      End If
      End If
      If A2 = 1 Then
      If Smv2 > 981 Then
         Portd.4 = 1
      Else
         Portd.4 = 0
      End If
      End If
      If A3 = 1 Then
      If Smv3 > 981 Then
         Portd.5 = 1
      Else
         Portd.5 = 0
      End If
      End If
      If Smv1 < 982 Or Smv2 < 982 Or Smv3 < 982 Then
         Portc.2 = 0
      Else
         Portc.2 = 1
      End If
   Call Zwangsladung
      If _sec = 00 Then
         Portd.3 = 1
         Portd.4 = 1
         Portd.5 = 1
         Portc.2 = 1
         Count1 = 0
         Initlcd
         Cls
         Do
         Count1 = Count1 + 1
         Call Get_voltage
         Call Datetime
            Locate 1 , 1
            Lcd "Erhaltung"
            If A1 = 1 Then
               Locate 2 , 1
               Lcd "A1: " ; Round_v1 ; " V   "
            End If
            If A2 = 1 Then
               Locate 3 , 1
               Lcd "A2: " ; Round_v2 ; " V   "
            End If
            If A3 = 1 Then
               Locate 4 , 1
               Lcd "A3: " ; Round_v3 ; " V   "
            End If
             Wait 1
             If Pind.2 = 1 Then
               Goto Begin
             End If
         Loop Until Count1 = 9
      End If
      If Pind.2 = 1 Then
         Goto Begin
      End If
Loop

Return

Zwangsladung:
If _hour = 17 Then
      Portb.4 = 1
      Portb.3 = 1
      Portb.2 = 1
      Initlcd
      Cls
      Locate 3 , 5
      Lcd "Zwangsladung"
      While _hour = 17
         Call Datetime
         Portc.2 = 0
         Portd.3 = 0
         Portd.4 = 0
         Portd.5 = 0
         Portd.6 = 0
         Portd.7 = 0
         Porta.7 = 0
         Wait 1
            If Pind.2 = 1 Then
               Goto Begin
            End If
      Wend
   Goto Begin
End If
Return


Normalladung:
Portb.4 = 0
Portb.3 = 0
Portb.2 = 1
Porta.7 = 0
Portd.3 = 1
Portd.4 = 1
Portd.5 = 1
Portc.2 = 1
Portd.6 = 1
Cls
Locate 1 , 1
Lcd "Ladung"
Call Get_akku
   If A1 = 0 Then
      Locate 2 , 1
      Lcd "A1: ---   "
   End If
   If A2 = 0 Then
      Locate 3 , 1
      Lcd "A2: ---   "
   End If
   If A3 = 0 Then
      Locate 4 , 1
      Lcd "A3: ---   "
   End If
Call Get_voltage
      If A1 = 1 Then
         Locate 2 , 1
         Lcd "A1: " ; Round_v1 ; " V   "
      End If
      If A2 = 1 Then
         Locate 3 , 1
         Lcd "A2: " ; Round_v2 ; " V   "
      End If
      If A3 = 1 Then
         Locate 4 , 1
         Lcd "A3: " ; Round_v3 ; " V   "
      End If
   L1 = 0
   L2 = 0
   L3 = 0
Do
Call Datetime
      If A1 = 1 Then
      If Smv1 > 981 Then
         Portd.3 = 1
      Else
         Portd.3 = 0
      End If
      End If
      If A2 = 1 Then
      If Smv2 > 981 Then
         Portd.4 = 1
      Else
         Portd.4 = 0
      End If
      End If
      If A3 = 1 Then
      If Smv3 > 981 Then
         Portd.5 = 1
      Else
         Portd.5 = 0
      End If
      End If
      If Portd.3 = 0 Or Portd.4 = 0 Or Portd.5 = 0 Then
         Portc.2 = 0
      Else
         Portc.2 = 1
      End If
      If _sec = 00 Or _sec = 30 Then
         Portd.3 = 1
         Portd.4 = 1
         Portd.5 = 1
         Portc.2 = 1
         Count1 = 0
         Initlcd
         Cls
         Do
         Count1 = Count1 + 1
         Call Get_voltage
         Call Datetime
            Locate 1 , 1
            Lcd "Ladung"
            If A1 = 1 Then
               Locate 2 , 1
               Lcd "A1: " ; Round_v1 ; " V   "
            End If
            If A2 = 1 Then
               Locate 3 , 1
               Lcd "A2: " ; Round_v2 ; " V   "
            End If
            If A3 = 1 Then
               Locate 4 , 1
               Lcd "A3: " ; Round_v3 ; " V   "
            End If
             Wait 1
             If Pind.2 = 1 Then
               Goto Begin
             End If
         Loop Until Count1 = 9
      End If
      If Pind.2 = 1 Then
         Goto Begin
      End If
Loop

Return



Get_akku:
Call Get_voltage:
   If Smv1 >= 500 Then
      A1 = 1
      Print "A1y"
   Else
      A1 = 0
      Print "A1n"
   End If
   If Smv2 >= 500 Then
      A2 = 1
      Print "A2y"
   Else
      A2 = 0
      Print "A2n"
   End If
   If Smv3 >= 500 Then
      A3 = 1
      Print "A3y"
   Else
      A3 = 0
      Print "A3n"
   End If
Return


Get_voltage:
Start Adc
Smv1 = 0
Smv2 = 0
Smv3 = 0
Count = 0
Do
   Mv1 = Getadc(0)
   Smv1 = Smv1 + Mv1
   Incr Count
Loop Until Count = 15
Smv1 = Smv1 / Count
Erg_v1 = Smv1 * 0.0140625
Round_v1 = Fusing(erg_v1 , "#.##")

Count = 0
Do
   Mv2 = Getadc(2)
   Smv2 = Smv2 + Mv2
   Incr Count
Loop Until Count = 15
Smv2 = Smv2 / Count
Erg_v2 = Smv2 * 0.0140625
Round_v2 = Fusing(erg_v2 , "#.##")

Count = 0
Do
   Mv3 = Getadc(1)
   Smv3 = Smv3 + Mv3
   Incr Count
Loop Until Count = 15
Smv3 = Smv3 / Count
Erg_v3 = Smv3 * 0.0140625
Round_v3 = Fusing(erg_v3 , "#.##")

Stop Adc
Return



Get_current:
Start Adc
Smc1 = 0
Smc2 = 0
Smc3 = 0

Count_x = 0
Do
Mc1 = Getadc(4)
Smc1 = Smc1 + Mc1
Incr Count_x
Loop Until Count_x = 5
Smc1 = Smc1 / Count_x
Erg_c1 = Smc1

Count_x = 0
Do
Mc2 = Getadc(5)
Smc2 = Smc2 + Mc2
Incr Count_x
Loop Until Count_x = 5
Smc2 = Smc2 / Count_x
Erg_c2 = Smc2

Count_x = 0
Do
Mc3 = Getadc(3)
Smc3 = Smc3 + Mc3
Incr Count_x
Loop Until Count_x = 5
Smc3 = Smc3 / Count_x
Erg_c3 = Smc3

Stop Adc
Return



Datetime:
I2cstart
I2cwbyte Ds1307w
I2cwbyte 0

I2cstart
I2cwbyte Ds1307r
I2crbyte _sec , Ack
I2crbyte _min , Ack
I2crbyte _hour , Ack
I2crbyte _weekday , Ack
I2crbyte _day , Ack
I2crbyte _month , Ack
I2crbyte _year , Nack
I2cstop
Locate 1 , 16
Lcd Bcd(_hour) ; ":" ; Bcd(_min)
_weekday = Makedec(_weekday)
_day = Makedec(_day)
_month = Makedec(_month)
_year = Makedec(_year)
_hour = Makedec(_hour)
_min = Makedec(_min)
_sec = Makedec(_sec)
If _hour = 16 And _min = 56 And _sec = 30 And Isset = 0 Then
Isset = 1
Call Settime
End If
If _hour = 16 And _min = 57 Then
Isset = 0
End If
Return


Settime:
_min = 55
_sec = Makebcd(_sec)
_min = Makebcd(_min)
_hour = Makebcd(_hour)
I2cstart
I2cwbyte Ds1307w
I2cwbyte 0
I2cwbyte _sec
I2cwbyte _min
I2cwbyte _hour
I2cstop
Call Datetime
Return

Setdate:
_day = Makebcd(_day)
_month = Makebcd(_month)
_year = Makebcd(_year)
I2cstart
I2cwbyte Ds1307w
I2cwbyte 3
I2cwbyte _weekday
I2cwbyte _day
I2cwbyte _month
I2cwbyte _year
I2cstop
Return


End