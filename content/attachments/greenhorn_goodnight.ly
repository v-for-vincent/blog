\version "2.16.0"
\score {
  \new Staff {
    \clef "treble_8"
    \time 12/8
    \key e \major
    % I
    <e, b, e gis d' e'>4. <e, b, e gis d' e'>8 r4 ais8 \bendAfter #-1 a8 gis8 e4. |
    % IV
    <a, e a cis' g'>4. <a, e a cis' g'>8 r8 b,8 d8 e8 g8 e4. |
    % I
    <e, b, e gis d' e'>4. <e, b, e gis d' e'>8 r4 ais8 \bendAfter #-1 a8 \bendAfter #+1 ais8 ais8 ais8 ais8 |
    % IV
    <a, e a cis' g'>4. <a, e a cis' g'>8 r4 ais'8 \bendAfter #-1 a'8 \bendAfter #+1 ais'8 ais'8 ais'8 ais'8 |
    % I
    <e, b, e gis d' e'>4. <e, b, e gis d' e'>8 r4 d'8 gis8 e8 e'4. |
    % V
    <b, dis a b fis'>4. <b, dis a b fis'>8 r4 a8 d8 b,8 e'4. |
    % IV
    <a, e a cis' g'>4. <a, e a cis' g'>8 r4 g'8 c'8 a8 a'4. |
    % V
    <b, dis a b fis'>4. <b, dis a b fis'>8 r4 b8 a8 dis8 b,4. |
    % I
    <e, b, e gis d' e'>1. |
  }
  \midi{}
  \layout{}
}
