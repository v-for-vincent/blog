\version "2.16.0"
\score {
  \new Staff {
    \clef "treble_8"
    \time 12/8
    \key e \major % actually not sure about this
    <e, b, e gis d' e'>4. <e, b, e gis d' e'>8 r4 ais8 \bendAfter #-1 a8 gis8 e4. |
  }
  \midi{}
  \layout{}
}
