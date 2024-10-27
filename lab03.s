# Conversion of RGB888 image to RGB565
# lab03 of MYY505 - Computer Architecture
# Department of Computer Engineering, University of Ioannina
# Aris Efthymiou

# This directive declares subroutines. Do not remove it!
.globl rgb888_to_rgb565, showImage

.data

image888:  # A rainbow-like image Red->Green->Blue->Red
    .byte 255, 0,     0
    .byte 255,  85,   0
    .byte 255, 170,   0
    .byte 255, 255,   0
    .byte 170, 255,   0
    .byte  85, 255,   0
    .byte   0, 255,   0
    .byte   0, 255,  85
    .byte   0, 255, 170
    .byte   0, 255, 255
    .byte   0, 170, 255
    .byte   0,  85, 255
    .byte   0,   0, 255
    .byte  85,   0, 255
    .byte 170,   0, 255
    .byte 255,   0, 255
    .byte 255,   0, 170
    .byte 255,   0,  85
    .byte 255,   0,   0
# repeat the above 5 times
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0
    .byte 255, 0,     0, 255,  85,   0 255, 170,   0, 255, 255,   0, 170, 255,   0, 85, 255,   0, 0, 255,   0, 0, 255,  85, 0, 255, 170, 0, 255, 255, 0, 170, 255, 0,  85, 255, 0,   0, 255, 85,   0, 255, 170,   0, 255, 255,   0, 255, 255,   0, 170, 255,   0,  85, 255,   0,   0

image565:
    .zero 512  # leave a 0.5Kibyte free space

.text
# -------- This is just for fun.
# Ripes has a LED matrix in the I/O tab. To enable it:
# - Go to the I/O tab and double click on LED Matrix.
# - Change the Height and Width (at top-right part of I/O window),
#     to the size of the image888 (6, 19 in this example)
# - This will enable the LED matrix
# - Uncomment the following and you should see the image on the LED matrix!
#    la   a0, image888
#    li   a1, LED_MATRIX_0_BASE
#    li   a2, LED_MATRIX_0_WIDTH
#    li   a3, LED_MATRIX_0_HEIGHT
#    jal  ra, showImage
# ----- This is where the fun part ends!

    la   a0, image888
    la   a3, image565
    li   a1, 19 # width
    li   a2,  6 # height
    jal  ra, rgb888_to_rgb565

    addi a7, zero, 10 
    ecall

# ----------------------------------------
# Subroutine showImage
# a0 - image to display on Ripes' LED matrix
# a1 - Base address of LED matrix
# a2 - Width of the image and the LED matrix
# a3 - Height of the image and the LED matrix
# Caution: Assumes the image and LED matrix have the
# same dimensions!
showImage:
    add  t0, zero, zero # row counter
showRowLoop:
    bge  t0, a3, outShowRowLoop
    add  t1, zero, zero # column counter
showColumnLoop:
    bge  t1, a2, outShowColumnLoop
    lbu  t2, 0(a0) # get red
    lbu  t3, 1(a0) # get green
    lbu  t4, 2(a0) # get blue
    slli t2, t2, 16  # place red at the 3rd byte of "led" word
    slli t3, t3, 8   #   green at the 2nd
    or   t4, t4, t3  # combine green, blue
    or   t4, t4, t2  # Add red to the above
    sw   t4, 0(a1)   # let there be light at this pixel
    addi a0, a0, 3   # move on to the next image pixel
    addi a1, a1, 4   # move on to the next LED
    addi t1, t1, 1
    j    showColumnLoop
outShowColumnLoop:
    addi t0, t0, 1
    j    showRowLoop
outShowRowLoop:
    jalr zero, ra, 0

# ----------------------------------------


# ----------------------------------------
# Write your code here.
# You may move the "return" instruction (jalr zero, ra, 0).
rgb888_to_rgb565:
    # Αποθήκευση καταχωρητών στοίβας
    addi sp, sp, -20
    sw s0, 0(sp)    # Αποθήκευση του s0 (χρήση για πλάτος)
    sw s1, 4(sp)    # Αποθήκευση του s1 (χρήση για δείκτη στη μνήμη προορισμού)
    sw s2, 8(sp)    # Αποθήκευση του s2 (χρήση για δείκτη στη μνήμη πηγής)
    sw s3, 12(sp)   # Αποθήκευση του s3 (για τον αριθμό pixel)
    sw s4, 16(sp)   # Αποθήκευση του s4 (μετρητής επαναλήψεων για debugging)

    # Αρχικοποίηση
    mul s3, a1, a2    # s3 = width * height (συνολικός αριθμός pixels)
    add s1, zero, a3  # s1 = Διεύθυνση προορισμού (RGB565)
    add s2, zero, a0  # s2 = Διεύθυνση αρχικής εικόνας (RGB888)
    add t0, zero, zero # t0 = Δείκτης pixel (ξεκινά από 0)
    add s4, zero, zero # s4 = Μετρητής επαναλήψεων

loop_pixels:
    # Έξοδος αν ολοκληρωθούν όλα τα pixels
    bge t0, s3, end_rgb888_to_rgb565

    # Debugging - Αύξηση του μετρητή επαναλήψεων και ecall για παρακολούθηση
    addi s4, s4, 1     # Αύξηση του μετρητή επαναλήψεων
    # Αν επιθυμείτε, προσθέστε εδώ `ecall` για παρακολούθηση

    # Φόρτωση των καναλιών R, G, B από το RGB888
    lbu t1, 0(s2)   # t1 = R (κόκκινο κανάλι)
    lbu t2, 1(s2)   # t2 = G (πράσινο κανάλι)
    lbu t3, 2(s2)   # t3 = B (μπλε κανάλι)

    # Μετατροπή σε RGB565
    srli t1, t1, 3       # R >> 3 για τα 5 πιο σημαντικά bits (5 bits)
    srli t2, t2, 2       # G >> 2 για τα 6 πιο σημαντικά bits (6 bits)
    srli t3, t3, 3       # B >> 3 για τα 5 πιο σημαντικά bits (5 bits)

    # Συνδυασμός καναλιών σε μορφή RGB565
    slli t1, t1, 11      # Μετατόπιση του R στα αριστερά κατά 11
    slli t2, t2, 5       # Μετατόπιση του G στα αριστερά κατά 5
    or t1, t1, t2       # Συνδυασμός R και G
    or t1, t1, t3       # Συνδυασμός όλων (RGB565)

    # Αποθήκευση του pixel RGB565
    sh t1, 0(s1)        # Αποθήκευση του 16-bit RGB565 στη διεύθυνση προορισμού

    # Ενημέρωση δεικτών
    addi s2, s2, 3      # Μετακίνηση στον επόμενο pixel στην RGB888 εικόνα (3 bytes)
    addi s1, s1, 2      # Μετακίνηση στον επόμενο pixel στην RGB565 εικόνα (2 bytes)
    addi t0, t0, 1      # Αύξηση του δείκτη pixel

    # Επιστροφή στην αρχή του loop
    j loop_pixels

end_rgb888_to_rgb565:
    # Debugging - ecall για παρακολούθηση στην έξοδο
    # Προσθέστε ecall εδώ για επιβεβαίωση εξόδου αν υπάρχει δυνατότητα

    # Αποκατάσταση των καταχωρητών από τη στοίβα
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    addi sp, sp, 20

    # Επιστροφή
    jalr zero, ra, 0

