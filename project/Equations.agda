open import Parameters

module Equations where --(G : GTypes) (O : Ops G) where

open import Types -- G O
open import Terms -- G O
open import Contexts -- G O
open import Substitution -- G O

open GTypes G
open Ops O

interleaved mutual
 
  data _⊢V_≡_ (Γ : Ctx) : {X : VType} → Γ ⊢V: X → Γ ⊢V: X → Set
  data _⊢M_≡_ (Γ : Ctx) : {UU : UType} → Γ ⊢M: UU → Γ ⊢M: UU → Set
  data _⊢K_≡_ (Γ : Ctx) : {KK : KType} → Γ ⊢K: KK → Γ ⊢K: KK → Set

  data _⊢V_≡_ where

    -- equivalence rules

    refl : {X : VType} {V : Γ ⊢V: X}
         ---------------------------
         → Γ ⊢V V ≡ V

    sym : {X : VType} {V  V' : Γ ⊢V: X}
      → Γ ⊢V V ≡ V'
      --------------------
      → Γ ⊢V V' ≡ V

    trans : {X : VType} { V W Z : Γ ⊢V: X}
      → Γ ⊢V V ≡ W
      → Γ ⊢V W ≡ Z
      --------------------------
      → Γ ⊢V V ≡ Z

    -- congruence rules

    prod-cong :
      {X Y : VType}
      {V₁ V₂ : Γ ⊢V: X}
      {W₁ W₂ : Γ ⊢V: Y}
      → Γ ⊢V V₁ ≡ V₂
      → Γ ⊢V W₁ ≡ W₂
      -----------------------------
      → Γ ⊢V ⟨ V₁ , W₁ ⟩ ≡ ⟨ V₂ , W₂ ⟩

    fun-cong :
        {X : VType} {U : UType}
        {M N : Γ ∷ X ⊢M: U}
      → (Γ ∷ X) ⊢M M ≡ N
      -------------------------
      → Γ ⊢V (fun M) ≡ (fun N)

    funK-cong :
      {X : VType} {K : KType}
      {M N : (Γ ∷ X) ⊢K: K}
      → (Γ ∷ X) ⊢K M ≡ N
      -----------------
      → Γ ⊢V funK M ≡ (funK N)

    runner-cong :
      {X : VType} {Σ Σ' : Sig} {C : KState}
      {R R' : ((op : Op) → (op ∈ₒ Σ) → co-op Γ Σ' C op)}
      → ((op : Op) → (p : op ∈ₒ Σ) → (Γ ∷ gnd (param op)) ⊢K R op p ≡ R' op p)
      ------------------------------------------------------------------------
      → Γ ⊢V runner R ≡ runner R'

    -- rules from the paper


    unit-η : {V : Γ ⊢V: gnd unit}
           ----------------------
           → Γ ⊢V V ≡ ⟨⟩

    fun : {X : VType}
      → {!!}
      ------------
      → Γ ⊢V {!!} ≡ {!!}

    funK : {X : VType}
      → {!!}
      ---------------
      → Γ ⊢V {!!} ≡ {!!}

    
    

  data _⊢M_≡_ where

    -- equivalence rules
    refl : {X : UType} {M : Γ ⊢M: X}
         ---------------------------
         → Γ ⊢M M ≡ M

    sym : {X : UType} {M  M' : Γ ⊢M: X}
      → Γ ⊢M M ≡ M'
      --------------------
      → Γ ⊢M M' ≡ M

    trans : {X : UType} { M N O : Γ ⊢M: X}
      → Γ ⊢M M ≡ N
      → Γ ⊢M N ≡ O
      --------------------------
      → Γ ⊢M M ≡ O
    -- congruence rules

    return-cong :
      {X : VType} {V W : Γ ⊢V: X} 
      → Γ ⊢V V ≡ W
      ------------------
      → Γ ⊢M return V ≡ return W

    ∘-cong :
      {X : VType} {U : UType}
      {V₁ V₂ : Γ ⊢V: X ⟶ᵤ U}
      {W₁ W₂ : Γ ⊢V: X}
      → Γ ⊢V V₁ ≡ V₂
      → Γ ⊢V W₁ ≡ W₂
      ----------------------
      → Γ ⊢M V₁ ∘ W₁ ≡ (V₂ ∘ W₂)

    opᵤ-cong :
      {X : VType} {Σ : Sig}
      {op : Op} {V₁ V₂ : Γ ⊢V: gnd (param op)}
      {M₁ M₂ : Γ ∷ gnd (result op) ⊢M: X ! Σ}
      → Γ ⊢V V₁ ≡ V₂
      → Γ ⊢M {!!} ≡ {!!}
      --------------------
      → Γ ⊢M opᵤ op V₁ M₁ ≡ opᵤ op V₂ M₂

    let-in-cong :
      {X Y : VType} {Σ : Sig}
      {M₁ M₂ : Γ ⊢M: X ! Σ}
      {N₁ N₂ : Γ ∷ X ⊢M: Y ! Σ}
      → Γ ⊢M M₁ ≡ M₂
      → Γ ⊢M {!!} ≡ {!!}
      --------------------
      → Γ ⊢M `let M₁ `in N₁ ≡ `let M₂ `in N₂

    match-with-cong :
      {X Y : VType} {U : UType}
      {V₁ V₂ : Γ ⊢V: X × Y}
      {M₁ M₂ : Γ ∷ X ∷ Y ⊢M: U}
      → Γ ⊢V V₁ ≡ V₂
      → Γ ⊢M {!!} ≡ {!!}
      ----------------------
      → Γ ⊢M (match V₁ `with M₁) ≡ (match V₂ `with M₂)


    using-at-run-finally-cong :
      {X Y : VType} {Σ Σ' : Sig} {C : KState}
      {V₁ V₂ : Γ ⊢V: Σ ⇒ Σ' , C}
      {W₁ W₂ : Γ ⊢V: gnd C}
      {M₁ M₂ : Γ ⊢M: X ! Σ}
      {N₁ N₂ : Γ ∷ X ∷ gnd C ⊢M: Y ! Σ'}
      → Γ ⊢V V₁ ≡ V₂
      → Γ ⊢V W₁ ≡ W₂
      → Γ ⊢M M₁ ≡ M₂
      → Γ ⊢M {!!} ≡ {!!}
      ------------------------
      → Γ ⊢M `using V₁ at W₁ `run M₁ finally N₁ ≡ `using {!!} at {!!} `run {!!} finally {!!}

    kernel-at-finally-cong :
      {X Y : VType} {Σ : Sig} {C : KState}
      {K₁ K₂ : Γ ⊢K: X ↯ Σ , C}
      {V₁ V₂ : Γ ⊢V: gnd C}
      {M₁ M₂ : Γ ∷ X ∷ gnd C ⊢M: Y ! Σ} 
      → Γ ⊢K K₁ ≡ K₂
      → Γ ⊢V V₁ ≡ V₂
      → Γ ⊢M {!!} ≡ {!!}
      ------------------------
      → Γ ⊢M kernel K₁ at V₁ finally M₁ ≡ kernel K₂ at V₂ finally M₂

    -- rules from the paper
    funM : {X : VType} {U : UType}
      → (funM : (Γ ∷ X) ⊢M: U)
      → Γ ⊢M {!!} ≡ {!!}

    let-beta-return_ : {X Y : VType} {Σ : Sig}  {U : UType} {V : Γ ⊢M: U}
      → (V : Γ ⊢V: X)
      → (N : Γ ∷ X ⊢M: Y ! Σ)
      ----------------------------
      → Γ ⊢M {!!} ≡ {!!}
      
    let-beta-op : {X Y : VType} {Σ : Sig} {V : VType}            -- TODO: naming conventions, e.g., let-beta-op
      → (op : Op)
      → (V : Γ ⊢V: gnd (param op))
      → (M : Γ ∷ gnd (result op) ⊢M: X ! Σ)
      → (N : Γ ∷ X ⊢M: Y ! Σ)
      --------------------------------
      → {!!}
      --→ Γ ⊢M Try (opᵤ op V M) With N
      --     ≡ opᵤ op V (Try M With (N [ wkᵣ ∘ᵣ exchᵣ ]ᵤᵣ))

    match-with-beta-prod : {X Y : VType} {U : UType} {V : Γ ⊢M: U}
      → (XxY : Γ ⊢V: X × Y)
      → (W : Γ ∷ X ∷ Y ⊢M: U)
      -----------------
      → {!!}
    --→ Γ ⊢M (Match XxY With W) ≡ {!!} -- Unsure
      
    match-with-beta-null : {X Y : VType} {U V : UType} {V : Γ ⊢M: U}
      → (XxY : Γ ⊢V: X × Y)
      → (B : Γ ⊢M: U)
      -----------------
      → {!!}
      --→ Γ ⊢M  (Match XxY With {!!}) ≡ B -- Unsure

    using-run-finally-beta-return :{U V W : VType} 
      → {!Γ ⊢V: !}
      → {!!}
      → {!!}
      ------------
      → {!!}
      --→ Γ ⊢M Using {!!} At {!!} Run (return {!!}) Finally (return {!!}) ≡ {!!}

    using-run-finally-beta-op :{U V W : VType} 
      → {!Γ ⊢V: !}
      → {!!}
      → {!!}
      ------------
      → {!!}
--→ Γ ⊢M Using {!!} At {!!} Run (return {!!}) Finally (return {!!}) ≡ {!!}

    kernel-at-finally-beta-return : {X : VType}
      → {!!}
      -------------------
      → {!!}
      
    kernel-at-finally-beta-getenv : {X : VType}
      → {!!}
      -------------------
      → {!!}
      
    kernel-at-finally-setenv : {X : VType}
      → {!!}
      -------------------
      → {!!}
      
    kernel-at-finally-beta-op : {X : VType}
      → (op : Op)
      → {!!}
      -------------------
      → Γ ⊢M {!!} ≡ {!!}


    let-in-beta-M : {X : VType}    -- let-eta
      → {!!}
      -------------------
      → Γ ⊢M {!!} ≡ {!!}
      
  data _⊢K_≡_ where

    -- equivalence rules
    refl : {X : KType} {K : Γ ⊢K: X}
         ---------------------------
         → Γ ⊢K K ≡ K

    sym : {X : KType} {K  K' : Γ ⊢K: X}
      → Γ ⊢K K ≡ K'
      --------------------
      → Γ ⊢K K' ≡ K

    trans : {X : KType} { K L M : Γ ⊢K: X}
      → Γ ⊢K K ≡ L
      → Γ ⊢K L ≡ M
      --------------------------
      → Γ ⊢K K ≡ M
    -- congruence rules

    return-cong :
      {X : VType} {Σ : Sig} {C : KState}
      {V₁ V₂ : Γ ⊢V: X}
      → Γ ⊢V V₁ ≡ V₂
      ----------------
      → Γ ⊢K return V₁ ≡ return V₂

    ∘-cong :
      {X : VType} {K : KType}
      {V₁ V₂ : Γ ⊢V: X ⟶ₖ K}
      {W₁ W₂ : Γ ⊢V: X}
      → Γ ⊢V V₁ ≡ V₂
      → Γ ⊢V W₁ ≡ W₂
      -----------------------
      → Γ ⊢K V₁ ∘ W₁ ≡ (V₂ ∘ W₂)

    let-in-cong :
      {X Y : VType} {Σ : Sig} {C : KState}
      {K₁ K₂ : Γ ⊢K:  X ↯ Σ , C}
      {L₁ L₂ : Γ ∷ X ⊢K: Y ↯ Σ , C}
      → Γ ⊢K K₁ ≡ K₂
      → Γ ⊢K {!!} ≡ {!!}
      ----------------
      → Γ ⊢K `let K₁ `in L₁ ≡ `let K₂ `in L₂

    match-with-cong :
      {X Y : VType} {K : KType}
      {V₁ V₂ : Γ ⊢V: X × Y}
      {K₁ K₂ : Γ ∷ X ∷ Y ⊢K: K} 
      → Γ ⊢V V₁ ≡ V₂
      → Γ ⊢K {!!} ≡ {!!}
      ----------------
      → Γ ⊢K match V₁ `with K₁ ≡ (match V₂ `with K₂)

    opₖ-cong :
      {X Y : VType} {Σ : Sig} {C : KState}
      {V₁ V₂ : Γ ⊢V: X}
      {K₁ K₂ : Γ ∷ Y ⊢K: X ↯ Σ , C}
      → Γ ⊢V V₁ ≡ V₂
      → Γ ⊢K {!!} ≡ {!!}
      ----------------
      → Γ ⊢K opₖ V₁ K₁ ≡ opₖ V₂ K₂

    getenv-cong :
      {X : VType} {C : KState} {Σ : Sig}
      {K₁ K₂ : Γ ∷ gnd C ⊢K: X ↯ Σ , C}
      → Γ ⊢K {!!} ≡ {!!}
      -----------------
      → Γ ⊢K getenv K₁ ≡ getenv K₂

    setenv-cong :
      {X : VType} {C : KState} {Σ : Sig}
      {V₁ V₂ : Γ ⊢V: gnd C}
      {K₁ K₂ : Γ ⊢K: X ↯ Σ , C}
      → Γ ⊢V V₁ ≡ V₂
      → Γ ⊢K K₁ ≡ K₂
      --------------------
      → Γ ⊢K setenv V₁ K₁ ≡ setenv V₂ K₂

    user-with-cong :
      {X Y : VType} {Σ : Sig} {C : KState}
      {M₁ M₂ : Γ ⊢M: X ! Σ}
      {K₁ K₂ : Γ ∷ X ⊢K: Y ↯ Σ , C}
      → Γ ⊢M M₁ ≡ M₂
      → Γ ⊢K {!!} ≡ {!!} 
      -------------------
      → Γ ⊢K user M₁ `with K₁ ≡ user M₂ `with K₂


    -- rules from the paper

    funK : {X : VType}
      → {!!}
      -------------------
      → Γ ⊢K {!!} ≡ {!!}

    let-in-beta-return : {X : VType}
      → {!!}
      -----------------
      → Γ ⊢K {!!} ≡ {!!}

    let-in-beta-op : {X : VType}
      → {!!}
      -----------------
      → Γ ⊢K {!!} ≡ {!!}

    let-in-beta-getenv : {X : VType}
      → {!!}
      -----------------
      → Γ ⊢K {!!} ≡ {!!}
    
    let-in-beta-setenv : {X : VType}
      → {!!}
      -----------------
      → Γ ⊢K {!!} ≡ {!!}
      
    math-with-beta-prod : {X : VType}
      → {!!}
      -------------------
      → Γ ⊢K {!!} ≡ {!!}
      
    match-with-beta-null : {X : VType}
      → {!!}
      -------------------
      → Γ ⊢K {!!} ≡ {!!}

    user-with-beta-return : {X : VType}
      → {!!}
      ----------------------
      → Γ ⊢K {!!} ≡ {!!}

    user-with-beta-op : {X : VType}
      → {!!}
      ----------------------
      → Γ ⊢K {!!} ≡ {!!}

    try-with-beta-K : {X : VType}
      → {!!}
      -------------------
      → Γ ⊢K {!!} ≡ {!!}

    GetSetenv : {C : KState} {X : VType} {Σ : Sig} {K : Γ ⊢K: X ↯ Σ , C}
      → (A : Γ ∷ gnd C ⊢K: X ↯ Σ , C)
      → (V : Γ ⊢V: gnd C)
      -------------
      → Γ ⊢K setenv V (getenv A) ≡ K -- Unsure

    SetGetenv : {C : KState} {X : VType} {Σ : Sig} {K : Γ ⊢K: X ↯ Σ , C}
      → {!!}
      → {!!}
      --------------
      → Γ ⊢K setenv {!!} (getenv {!!}) ≡ setenv {!!} {!!}
      
    SetSetenv : {C C' : KState} {X : VType} {Σ : Sig} {K : Γ ⊢K: X ↯ Σ , C}
      → (W : Γ ⊢V: gnd C)
      → (V : Γ ⊢V: gnd C)
      --------------
      → Γ ⊢K setenv V (setenv W K) ≡ setenv W K

    GetOpEnv : {X : VType}
      → {!!}
      -----------------
      → Γ ⊢K {!!} ≡ {!!}

    SetOpEnv : {X : VType}
      → {!!}
      ----------------
      → Γ ⊢K {!!} ≡ {!!}


