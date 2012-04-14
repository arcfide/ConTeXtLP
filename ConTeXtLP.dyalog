:Namespace ConTeXtLP

    ⎕IO ⎕ML←0 0

    ∇ Main;file;chunk
      file←(⍴FileMsg)↓⍞⊣⍞←FileMsg←'Enter the name of the file to tangle: '
      chunk←(⍴ChunkMsg)↓⍞⊣⍞←ChunkMsg←'Enter the name of the chunk to tangle: '
      chunk Tangle file
    ∇

      Tangle←{
          ⍺←⊢ ⋄ chunk←⊃⍺ '*' ⋄ in out←⍵
          tie←in⎕NTIE 0
          pat←'^\\startChunk{\s*(.*[^\s])\s*}\s*\n'
          pat,←'((?:.|\n)*?)\\endChunk\s*\n'
          ns cs←⊂[0]↑(pat⎕S Extract⍠'Mode' 'M') tie
          tie←⎕NUNTIE tie
          ns cs←(⊂ns[sv]),⊂cs[sv←⍋↑ns]
          ns cs←(⊂pv/ns),⊂⊃∘(,/)¨(pv←1,2≢/ns)⊂cs
          output←ns cs Resolve cs[ns⍳⊂chunk]
          ⎕←'Tangling complete.'⊣output Write out          
      }

      Extract←{
        1≥⍴⍵.Offsets: ⍬
        no co←1↓⍵.Offsets
        nl cl←1↓⍵.Lengths
        (⍵.Block[no+⍳nl])(⍵.Block[co+⍳cl])
      }
      
      Resolve←{
          ns cs←⍺ ⋄ body←⍵
          pat←'/BTEX\\chunkRef{\s*(.*)\s*}/ETEX'
          nbody←(pat⎕R (ns cs∘Subst)⍠'ResultText' 'Simple') body
          nbody≡body: body
          ns cs ∇ nbody
      }
      
      Subst←{
          ns cs←⍺
          ⊃cs[ns⍳⊂⍵.Block[(1↓⍵.Offsets)+⍳1↓⍵.Lengths]]
      }
      
      Write←{
          22::⍵ ⎕NCREATE 0
          _←0 ⎕NRESIZE tie←⍵ ⎕NTIE 0
          (⎕UCS 'UTF-8'⎕UCS ⍺)⎕NREPLACE tie,0,80
      }

:EndNamespace
