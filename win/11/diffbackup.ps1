# �����o�b�N�A�b�v�p�X�N���v�g

# �^�X�N�X�P�W���[���ɓo�^����ꍇ�̃p�����[�^
#    �v���O����/�X�N���v�g: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe
#    �����̒ǉ�           : -Command "<�X�N���v�g�̃p�X>\diffbackup.ps1"
#    �J�n                 : �w��Ȃ�

# �o�b�N�A�b�v���ƃo�b�N�A�b�v��̃h���C�u�̒�`
$SRCDRIVE = "E"
$DSTDRIVE = "D"

# �o�b�N�A�b�v���O�̕ۑ���
$bkfile = "${SRCDRIVE}:\backuplog\$(Split-Path -Leaf $PSCommandPath)_$(Get-Date -Format yyyyMMdd).log"

# �o�b�N�A�b�v���̃f�B���N�g�����̃t�H���_�ꗗ���擾
$bkdirs = Get-ChildItem "${SRCDRIVE}:\"

# �o�b�N�A�b�v���̊e�t�H���_���R�s�[���Ă���
foreach ( $dir in $bkdirs ){

    $srcdir = "${SRCDRIVE}:\${dir}"
    $dstdir = "${DSTDRIVE}:\${dir}"

    robocopy $srcdir $dstdir /COPY:DATO /R:1 "/LOG+:${bkfile}" /NP /NFL /NDL

}
