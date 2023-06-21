from key_defs import *
import os

SHARED_DATA_SECTIONS_FILE = "/home/osboxes/Desktop/conattest/trampoline_lib/shared_data_sections.S"
# CODE_SECTION_SIZE = 4096*16
# SHARED_DATA_SECTIONS_SIZE = 4096*8
# DATA_SECTION_SIZE = 4
CODE_SECTION_SIZE = 4
#SHARED_DATA_SECTIONS_SIZE = 32*1024 #filename copter
#SHARED_DATA_SECTIONS_SIZE = 4*256 #control copter
# SHARED_DATA_SECTIONS_SIZE = 32*1024 #filename rover
# SHARED_DATA_SECTIONS_SIZE = 2*256 #control rover
SHARED_DATA_SECTIONS_SIZE = 2 #opration syringe
# SHARED_DATA_SECTIONS_SIZE = 2
DATA_SECTION_SIZE = 4

# .section .DATA_REGION_0__share , "axw"
# .skip 4096

# .section .DATA_REGION_1__share , "axw"
# .skip 4096
def AMI_add_shared_data_code(corresponding_data_section):
    section = []
    section_name  = '.section %s_share , "axw"' % corresponding_data_section
    section_content = '.skip %i' % (SHARED_DATA_SECTIONS_SIZE)
    section.append(section_name)
    section.append(section_content)
    return section



def AMI_write_shared_data_code(shared_data_code_str):
    with open(SHARED_DATA_SECTIONS_FILE, "w") as shared_data_file:
        shared_data_file.write(shared_data_code_str)



def write_linker(template_linker, linker_out, text_str,data_str):
    with open(template_linker) as infile:
        with open(linker_out,'w') as outfile:
            for line in infile.readlines():
                if '<HEXBOX_TEXT_SECTIONS>' in line:
                    outfile.write(text_str)
                elif '<HEXBOX_DATA_SECTIONS>' in line:
                    outfile.write(data_str)
                else:
                    outfile.write(line)


def AMI_write_linker(template_linker, linker_out, text_data_str):

    with open(template_linker) as infile:
        with open(linker_out, 'w') as outfile:
            for line in infile.readlines():
                if '<HEXBOX_TEXT_SECTIONS>' in line:
                    outfile.write(text_data_str)
                elif '<HEXBOX_DATA_SECTIONS>' in line:
                    continue
                else:
                    outfile.write(line)



def make_linker_script(template_linker, linker_out, partitions):
    text_str, data_str = get_sections_strings_from_partition(partitions)
    # print(text_str)
    # print(data_str)

    # text_data_str = AMI_get_sections_strings_from_partition(partitions)

    write_linker(template_linker, linker_out, text_str,data_str)

section_start_address = []

def AMI_make_linker_script(template_linker, linker_out, partitions):

    sect_addr_filename = "/home/osboxes/Desktop/conattest/ardupilot/sec_mask_result.txt"
    # wait for compartment start address
    if not os.path.isfile(sect_addr_filename):
        return

    with open(sect_addr_filename, 'r') as file:
        for line in file:
            addr_mask = line.split()
            section_start_address.append(addr_mask[0])

    text_data_str, shared_data_code_str = AMI_get_sections_strings_from_partition(partitions)

    # print("------test_data_str--------\n")
    # print(text_data_str)
    # print("\n")

    AMI_write_linker(template_linker, linker_out, text_data_str)

    AMI_write_shared_data_code(shared_data_code_str)



def set_code_sections(name,addr,size):
    section = []
    section.append("\t%s 0x%x :" % (name,addr))
    section.append("\t{")
    section.append("\t_%s_start = .;" % name)
    section.append("\t*(%s);" % name)
    section.append("\t*(%s*);" % name)
    section.append("\t_%s_end = . ;" % name)
    section.append("\t} \n")
    return section

def set_ram_sections(name,addr,size):
    data_section = []
    start_var = name+"_vma_start"
    data_section_name = '%s_data' % name
    declare_str =  "%s = LOADADDR(%s);" % (start_var, data_section_name)
    data_section.append("\t%s" %declare_str)
    data_section.append("\t%s 0x%x :" % (data_section_name,addr))
    data_section.append("\t{")
    data_section.append("\t%s_data_start = .;" % name)
    #data_section.append("\t. = ALIGN(%i);" % align)
    data_section.append("\t%s_mpu_start = .;" % name)
    data_section.append("\t*(%s);" % data_section_name)
    data_section.append("\t*(%s*);" % data_section_name)
    data_section.append("\t. = ALIGN(%i);" % 4)
    data_section_end_var = "%s_data_end" % name
    data_section.append("\t%s = .;" % data_section_end_var)
    data_section.append("\t} AT>FLASH\n")
    # BSS Section
    bss_section_name = '%s_bss' %name
    data_section.append("\t%s %s :" % (bss_section_name,data_section_end_var))
    data_section.append("\t{")
    data_section.append("\t%s_bss_start = .;" % name)
    data_section.append("\t. = ALIGN(%i);" % 4)
    data_section.append("\t*(%s);" % bss_section_name)
    data_section.append("\t*(%s*);" % bss_section_name)
    data_section.append("\t. = ALIGN(%i);" % 4)
    data_section.append("\t%s_bss_end = .;" % name)
    data_section.append("\t} \n")
    return data_section

def get_code_sections(name, align, offset=False):
    text_section = []
    if offset:
        text_section.extend(add_flash_filler(offset,align))
    #specify the start address of each section
    text_section.append("\t. = %s; " % (section_start_address[int(name[-2])-1]))
    text_section.append("\t%s  ALIGN(%i): " % (name, align))
    text_section.append("\t{")
    #text_section.append("\t. = ALIGN(%i);" % align)
    text_section.append("\tPROVIDE(%s_start = .);" % name)
    text_section.append("\t*(%s);" % name)
    text_section.append("\t*(%s*);" % name)
    text_section.append("\tPROVIDE(%s_end = . );" % name)
    # text_section.append("\t} >FLASH\n")
    text_section.append("\t} \n")    
    return text_section

def add_ram_filler(offset,align):
    data_section = []
    data_section.append("\t.ram_filler : ")
    data_section.append("\t{")
    data_section.append("\t\t. = . + %i;" % offset)
    data_section.append("\t\t. = ALIGN(%i);" % align)
    data_section.append("\t} >RAM\n")
    return data_section

def add_flash_filler(offset,align):
    data_section = []
    data_section.append("\t.flash_filler : ")
    data_section.append("\t{")
    data_section.append("\t\t. = . + %i;" % offset)
    data_section.append("\t\t. = ALIGN(%i);" % align)
    data_section.append("\t} >FLASH\n")
    return data_section

def get_data_sections(name,align,offset=False):
    data_section =[]
    if offset:
        data_section.extend(add_ram_filler(offset,align))
    #Data Section

    start_var = name+"_vma_start"
    data_section_name = '%s_data' % name
    declare_str =  "%s = LOADADDR(%s);" % (start_var, data_section_name)
    data_section.append("\t%s" %declare_str)
    data_section.append("\t%s ALIGN(%i):" % (data_section_name, align))
    data_section.append("\t{")
    data_section.append("\t%s_data_start = .;" % name)
    data_section.append("\t. = ALIGN(%i);" % align)
    data_section.append("\t%s_mpu_start = .;" % name)
    data_section.append("\t*(%s);" % data_section_name)
    data_section.append("\t*(%s*);" % data_section_name)
    data_section.append("\t. = ALIGN(%i);" % 4)
    data_section.append("\t%s_data_end = .;" % name)
    # data_section.append("\t} >RAM AT>FLASH\n")
    data_section.append("\t} \n")
    # BSS Section
    bss_section_name = '%s_bss' %name
    data_section.append("\t%s : " % (bss_section_name))
    data_section.append("\t{")
    data_section.append("\t%s_bss_start = .;" % name)
    data_section.append("\t. = ALIGN(%i);" % 4)
    data_section.append("\t*(%s);" % bss_section_name)
    data_section.append("\t*(%s*);" % bss_section_name)
    data_section.append("\t. = ALIGN(%i);" % 4)
    data_section.append("\t%s_bss_end = .;" % name)
    # data_section.append("\t} >RAM\n")
    data_section.append("\t} \n")

    return data_section


def get_shared_data_section(name, align, offset=False):
    data_section =[]
    if offset:
        data_section.extend(add_ram_filler(offset,align))
    #Data Section

    start_var = name+"_svma_start"
    data_section_name = '%s_share' % name
    declare_str =  "%s = LOADADDR(%s);" % (start_var, data_section_name)
    data_section.append("\t%s" %declare_str)
    data_section.append("\t%s ALIGN(%i):" % (data_section_name, align))
    data_section.append("\t{")
    data_section.append("\t%s_sdata_start = .;" % name)
    data_section.append("\t. = ALIGN(%i);" % align)
    data_section.append("\t%s_smpu_start = .;" % name)
    data_section.append("\t*(%s);" % data_section_name)
    data_section.append("\t*(%s*);" % data_section_name)
    data_section.append("\t. = ALIGN(%i);" % 4)
    data_section.append("\t%s_sdata_end = .;" % name)
    # data_section.append("\t} >RAM AT>FLASH\n")
    data_section.append("\t} \n")

    return data_section    


def get_global_data_section(name, align, offset=False):
    data_section =[]
    if offset:
        data_section.extend(add_ram_filler(offset,align))
    #Data Section

    start_var = name+"_vma_start"
    data_section_name = '%s_data' % name
    declare_str =  "%s = LOADADDR(%s);" % (start_var, data_section_name)
    data_section.append("\t%s" %declare_str)
    data_section.append("\t%s ALIGN(%i):" % (data_section_name, align))
    data_section.append("\t{")
    data_section.append("\t%s_data_start = .;" % name)
    data_section.append("\t. = ALIGN(%i);" % align)
    data_section.append("\t%s_mpu_start = .;" % name)
    data_section.append("\t*(%s);" % data_section_name)
    data_section.append("\t*(%s*);" % data_section_name)
    data_section.append("\t. = ALIGN(%i);" % 4)
    data_section.append("\t%s_data_end = .;" % name)
    # data_section.append("\t} >RAM AT>FLASH\n")
    data_section.append("\t} \n")

    return data_section 



def get_sections_strings_from_partition(partitions):

    data_section = []
    text_section = []
    for r_id in sorted(partitions['Regions'].keys()):
        region = partitions['Regions'][r_id]
        # print(r_id)
        # print(region)

        #print "Adding to Linker: ", r_id
        align = 0

        if region['Type'] =='Code':
            text_section.extend(get_code_sections(r_id,align))
        else:
            data_section.extend(get_data_sections(r_id,align))

    data_str = "\n".join(data_section)
    text_str = "\n".join(text_section)

    # print (data_str)
    # print("+++++++++++++")
    # print (text_str)
    return text_str, data_str


def AMI_get_sections_strings_from_partition(partitions):

    data_text_section = []
    shared_data_section = []
    shared_data_code = []

    # align = SHARED_DATA_SECTIONS_SIZE
    align = CODE_SECTION_SIZE
    data_align = DATA_SECTION_SIZE
    shared_data_align = SHARED_DATA_SECTIONS_SIZE

    shared_global_data_section = DATA_REGION_KEY + '%i_' % 0
    data_text_section.extend(get_global_data_section(shared_global_data_section, shared_data_align))




    for r_id in sorted(partitions['Regions'].keys()):
        # print(r_id)
        region = partitions['Regions'][r_id]
        text_section = None
        data_section = None
        shared_data_section = None
        if region['Type'] == 'Code':
            text_section = get_code_sections(r_id, align)
            # jinwen move it to here for debug
            data_text_section.extend(text_section)


            # reg_id = type2count[CODE_REGION_KEY]
            # type2count[CODE_REGION_KEY] += 1
            # reg_name = CODE_REGION_KEY +'%i_' % reg_id
            # reg_ty = CODE_REGION_KEY

            #construction data section name with the same id as code section
            end_index = r_id.find('_',13)
            # reg_id = r_id[13]
            reg_id = r_id[13: end_index]
            # print reg_id
            corresponding_data_section = DATA_REGION_KEY + '%i_' % int(reg_id)

            # print(corresponding_data_section)

            #get shared data section string
            shared_data_section = get_shared_data_section(corresponding_data_section, shared_data_align)
            
            #jinwen commend to move shared data to one region
            #add shared data section string into link script string
            data_text_section.extend(shared_data_section)

            #add shared data codes string
            # shared_data = AMI_add_shared_data_code(corresponding_data_section)
            # print shared_data
            shared_data_code.extend(AMI_add_shared_data_code(corresponding_data_section))

            #generate shared data code into shared_data_section.S

            if partitions['Regions'].has_key(corresponding_data_section):
                # print(corresponding_data_section)
                data_section = get_data_sections(corresponding_data_section, data_align)
                data_text_section.extend(data_section)
                #jinwen comment for debug
                # data_text_section.extend(text_section)

            else:
                #jinwen comment for debug
                # data_text_section.extend(text_section)
                pass

    # print shared_data_code

    data_text_str = "\n".join(data_text_section)

    shared_data_code_str = "\n".join(shared_data_code)

    return data_text_str, shared_data_code_str



def get_hexbox_rt_code_region():
    code_region = []
    code_region.append('    .hexbox_rt_code :')
    code_region.append('    {')
    code_region.append('        PROVIDE_HIDDEN(hexbox_rt_code__start = .);')
    code_region.append('        *(.hexbox_rt_code)')
    code_region.append('        *(.hexbox_rt_code*)')
    code_region.append('        PROVIDE_HIDDEN(hexbox_rt_code__end = .);')
    code_region.append('    } >FLASH')
    code_region.append('')
    return code_region


def get_hexbox_rt_data_region():
    data_region = []
    data_region.append('    .hexbox_rt_ram__vma_start = LOADADDR(.hexbox_rt_ram);')
    data_region.append('    .hexbox_rt_ram :')
    data_region.append('    {')
    data_region.append('    . = ALIGN(4);')
    data_region.append('    .hexbox_rt_ram__start = .;')
    data_region.append('    *(.hexbox_rt_ram);')
    data_region.append('    *(.hexbox_rt_ram*);')
    data_region.append('    . = ALIGN(4);')
    data_region.append('    .hexbox_rt_ram__end = .;')
    data_region.append('    } >RAM AT>FLASH')
    data_region.append('')
    return data_region


def next_power_2(size):
    if size == 0:
        return 0
    return 1 << (size - 1).bit_length()
