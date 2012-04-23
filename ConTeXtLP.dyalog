:Namespace ConTeXtLP

    ⎕IO ⎕ML←0 0

      Tangle←{
          ⍺←⊢ ⋄ chunk←⊃⍺ '*' ⋄ in out←⍵
          ⎕←'Tangling ''',(chunk),''' in ''',(in),''' to ''',out,''''
          tie←in⎕NTIE 0
          pat←'^\\defchunk{\s*(.*[^\s])\s*}\s*\n'
          pat,←'((?:.|\n)*?)\\stopchunk\s*\n'
          ns cs←⊂[0]↑(pat⎕S Extract⍠'Mode' 'M') tie
          0=⍴ns: 0 0⍴⎕←'No chunks found.'
          tie←⎕NUNTIE tie
          ns cs←(⊂ns[sv]),⊂cs[sv←⍋↑ns]
          ns cs←(⊂pv/ns),⊂⊃∘(,/)¨(pv←1,2≢/ns)⊂cs
          (⍴ns)=nsi←ns⍳⊂chunk:'UNKNOWN CHUNK'⎕SIGNAL 11
          output←ns cs Resolve cs[nsi]
          output Write out          
      }

      Extract←{
          1≥⍴⍵.Offsets: ⍬
          no co←1↓⍵.Offsets
          nl cl←1↓⍵.Lengths
          (⍵.Block[no+⍳nl])(⍵.Block[co+⍳cl])
      }
      
      Resolve←{
          ns cs←⍺ ⋄ body←⍵
          pat←'/BTEX\\chunk{\s*(.*)\s*}/ETEX'
          nbody←(pat⎕R (ns cs∘Subst)⍠'ResultText' 'Simple') body
          nbody≡body: body
          ns cs ∇ nbody
      }
      
      Subst←{
          ns cs←⍺
          r←(1↓⍵.Offsets)+⍳1↓⍵.Lengths
          i←ns⍳⊂⍵.Block[r]
          ⊃i⌷(cs,⊂' ')
      }
      
      ∇ dat Write fn;tie
        :Trap 22
            tie←fn ⎕NCREATE 0
        :Else
            tie←fn ⎕NTIE 0
            fn ⎕NERASE tie
            tie←fn ⎕NCREATE 0
        :EndTrap
        (⎕UCS'UTF-8'⎕UCS dat)⎕NAPPEND tie,80
        ⎕NUNTIE tie
      ∇

:EndNamespace
