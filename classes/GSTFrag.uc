class GSTFrag extends Frag;

function ServerThrow() {
    local GSTHumanPawn gsHP;

    super.ServerThrow();
    gsHP= GSTHumanPawn(Instigator);
    if (gsHP != none) {
        gsHp.addFragToss();
    }
}
