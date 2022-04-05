#!/usr/bin/env bash
#!/usr/bin bash
# Various bash bitcoin tools
#
# This script uses GNU tools.  It is therefore not guaranted to work on a POSIX
# system.
#
# Requirements are detailed in the accompanying README file.
#
# Copyright (C) 2013 Lucien Grondin (grondilu@yahoo.fr)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

secp256k1="I16i7sb0sa[[_1*lm1-*lm%q]Std0>tlm%Lts#]s%[Smddl%x-lm/
rl%xLms#]s~[[L0s#0pq]S0d0=0l<~2%2+l<*+[0]Pp]sE[_1*l%x]s_[+l%x]s+
483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8
79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798
2 100^ds<d14551231950B75FC4402DA1732FC9BEBF-sn1000003D1-dspsml<*
+sGi[*l%x]s*[-l%x]s-[l%xsclmsd1su0sv0sr1st[q]SQ[lc0=Qldlcl~xlcsd
scsqlrlqlu*-ltlqlv*-lulvstsrsvsulXx]dSXxLXs#LQs#lrl%x]sI[lpd1+4/
r|]sR[lpSm[+lCxq]S0[l1lDxlCxq]Sd[0lCxq]SzdS1rdS2r[L0s#L1s#L2s#Ld
s#Lms#LCs#]SCd0=0rd0=0r=dl1l</l2l</l-xd*l1l<%l2l<%l+xd*+0=zl2l</
l1l</l-xlIxl2l<%l1l<%l-xl*xd2lm|l1l</l2l</+l-xd_3Rl1l</rl-xl*xl1
l<%l-xrl<*+lCx]sA[lpSm[LCxq]S0dl<~SySx[Lms#L0s#LCs#Lxs#Lys#]SC0
=0lxd*3*la+ly2*lIxl*xdd*lx2*l-xd_3Rlxrl-xl*xlyl-xrl<*+lCx]sD[rs.
0r[rl.lAxr]SP[q]sQ[d0!<Qd2%1=P2/l.lDxs.lLx]dSLxs#LPs#LQs#]sM[[d2
%1=_q]s2 2 2 8^^~dsxd3lp|rla*+lb+lRxr2=2d2%0=_]sY[2l<*2^+]sU[d2%
2+l<*rl</+]sC[l<~dlYx3R2%rd3R+2%1=_rl<*+]s>[dlGrlMxl</ln%rlnSmlI
xLms#_4Rd_5R*+*ln%]sS"

encodeBase58() {
  echo -n "$1" | sed -e's/^\(\(00\)*\).*/\1/' -e's/00/1/g' | tr -d '\n'
  dc -e "16i ${1^^} [3A ~r d0<x]dsxx +f" |
    while read -r n; do echo -n "${base58[n]}"; done
}

# base58() {
#   if
#     local -a base58_chars=(
#       1 2 3 4 5 6 7 8 9
#       A B C D E F G H J K L M N P Q R S T U V W X Y Z
#       a b c d e f g h i j k m n o p q r s t u v w x y z
#     )
#     local OPTIND OPTARG o
#     getopts hdvc o
#   then
#     shift $((OPTIND - 1))
#     case $o in
#     h)
#       cat <<-END_USAGE
# 	${FUNCNAME[0]} [options] [FILE]

# 	options are:
# 	  -h:	show this help
# 	  -d:	decode
# 	  -c:	append checksum
#           -v:	verify checksum

# 	${FUNCNAME[0]} encode FILE, or standard input, to standard output.

# 	With no FILE, encode standard input.

# 	When writing to a terminal, ${FUNCNAME[0]} will escape non-printable characters.
# 	END_USAGE
#       ;;
#     d)
#       local input
#       read -r input <"${1:-/dev/stdin}"
#       if [[ "$input" =~ ^1.+ ]]; then
#         printf "\x00"
#         ${FUNCNAME[0]} -d <<<"${input:1}"
#       elif [[ "$input" =~ ^[$(printf %s ${base58_chars[@]})]+$ ]]; then
#         {
#           printf "s%c\n" "${base58_chars[@]}" | nl -v 0
#           sed -e i0 -e 's/./ 58*l&+/g' -e aP <<<"$input"
#         } | dc
#       elif [[ -n "$input" ]]; then
#         return 1
#       fi |
#         if [[ -t 1 ]]; then
#           cat -v
#         else
#           cat
#         fi
#       ;;
#     v)
#       tee >(${FUNCNAME[0]} -d "$@" | head -c -4 | ${FUNCNAME[0]} -c) |
#         uniq | { read -r && ! read -r; }
#       ;;
#     c)
#       tee >(
#         openssl dgst -sha256 -binary |
#           openssl dgst -sha256 -binary |
#           head -c 4
#       ) <"${1:-/dev/stdin}" |
#         ${FUNCNAME[0]}
#       ;;
#     esac
#   else
#     xxd -p -u "${1:-/dev/stdin}" |
#       tr -d '\n' |
#       {
#         read hex
#         while [[ "$hex" =~ ^00 ]]; do
#           echo -n 1
#           hex="${hex:2}"
#         done
#         if test -n "$hex"; then
#           dc -e "16i0$hex Ai[58~rd0<x]dsxx+f" |
#             while read -r; do
#               echo -n "${base58_chars[REPLY]}"
#             done
#         fi
#         echo
#       }
#   fi
# }
