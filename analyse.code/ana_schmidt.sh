#!/bin/bash
 
# Kreuzreferenz-Liste fuer Bezeichner in C-Programmen
# $1 : C Datei
 
# ------------------------------
 
# alle C Schluesselwoerter
 
function ckeywords () {
  cat << 'ende keywords'
auto
break
case
char
const
continue
default
do
double
else
enum
extern
float
for
goto
if
int
long
register
return
short
signed
sizeof
static
struct
switch
typedef
union
unsigned
void
volatile
while
 
ende keywords
}
 
# ------------------------------
 
# alle Bezeichner aus einem C Programm
# ohne Schluesselwoerter
 
function identifier () {
    (
    cat "$1" \
    | tr -sc A-Za-z_0-9 '\012' \
    | sed 's|^[0-9].*$||' \
    | sort -u
 
    ckeywords
    ckeywords
    ) \
    | sort \
    | uniq -u
 
}
 
# ------------------------------
 
function zeilennummern () {
    local ident
 
    ident=$1
    shift
 
    cat "$@" \
    | grep -n "\<$ident\>" \
    | sed 's|:.*$||' 
}
 
# ------------------------------
 
# das "Hauptprogramm"
 
file="$1"
 
for id in $(identifier "$file")
do
   echo $id
   zeilennummern $id "$file" \
     | pr -8 -b -t
   echo ""
done
 
# ------------------------------
