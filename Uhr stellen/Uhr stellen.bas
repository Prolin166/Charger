$regfile = "m32def.dat"
$crystal = 8000000
$baud = 9600
$hwstack = 100
$swstack = 100
$framesize = 100

Config Sda = Portc.1
Config Scl = Portc.0

Dim _weekday As Byte
Dim _day As Byte
Dim _month As Byte
Dim _year As Word
Dim _sec As Byte
Dim _min As Byte
Dim _hour As Byte

Dim Ds1307w As Byte
Dim Ds1307r As Byte



Ds1307w = &B11010000
Ds1307r = &B11010001

_day = 25
_month = 11
_year = 19
_sec = 00
_min = 54
_hour = 18
_weekday = 01

Rem Zeitsetzen
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

Rem Datumsetzen
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

Rem Datum und Zeit holen
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

Waitms 1000

Print "Uhrzeit ist eingestellt!"

Do

Print "---------------------------------------"
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
Print Bcd(_weekday)
Print Bcd(_day) ; ":" ; Bcd(_month) ; ":" ; Bcd(_year)
Print Bcd(_hour) ; ":" ; Bcd(_min) ; ":" ; Bcd(_sec)
Waitms 1000

Loop


Return