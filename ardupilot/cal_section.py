import subprocess
import math


def generate_masks(addresses):
    """Generate masks for the spaces between each pair of adjacent addresses"""
    masks = []
    for i in range(len(addresses) - 1):
        # Calculate the mask for the space between this address and the next one
        mask = addresses[i + 1] - addresses[i] - 1
        masks.append(mask)
    return masks


def write_lists_to_file(filename, lists):
    """Write a list of lists to a file, with items in each list separated by spaces"""
    with open(filename, 'w') as f:
        for sublist in lists:
            line = ' '.join(str(item) for item in sublist)
            f.write(line + '\n')


def count_trailing_zeros(n):
    """Count the number of trailing zeros in the binary representation of n"""
    # Convert n to binary and remove the '0b' prefix
    binary = bin(n)[2:]
    # Reverse the binary string and find the first occurrence of '1'
    idx = binary[::-1].find('1')
    return idx if idx != -1 else 0


def next_power_of_two(n):
    """Find the smallest power of 2 greater than n"""
    return 2 ** math.ceil(math.log(n, 2))

def calculate_new_addresses(address_sizes):
    """Calculate new addresses based on the list of (address, size) pairs"""
    new_addresses = []
    last_address = 0
    for address, size in address_sizes:
        # If the current address is less than the last address plus size,
        # the new address needs to be larger
        if address < last_address + size:
            address = last_address + size
        # The new address should also be a power of 2
        new_address = next_power_of_two(address)
        new_addresses.append(int(new_address))
        last_address = new_address
    return new_addresses


def cal_section_start_addr():

	code_substr = "CODE_REGION"

	code_addr_size_list = []

	command = "readelf -S /home/osboxes/Desktop/conattest/ardupilot/build/sitl/bin/arducopter"

	output = subprocess.check_output(command, shell=True, universal_newlines=True)
	
	with open('/home/osboxes/Desktop/conattest/ardupilot/readelf_result.txt', 'w') as f:
	    f.write(output)

	with open('/home/osboxes/Desktop/conattest/ardupilot/readelf_result.txt', 'r') as file:
	    # Read each line
	    for line in file:
	        # Split the line by spaces and print the result
	        words = line.split()
	        # print(words)
	        if len(words) > 2 and code_substr in words[1]:
	       		# print(words[1])
	       		# print(int(words[3], 16))
	       		code_addr_size_list.append((int(words[3], 16), int(words[5], 16)))

	# print(code_list)

	new_addresses = calculate_new_addresses(code_addr_size_list)
	# print(new_addresses)
	# for i in new_addresses:
	# 	print(hex(int(i)))
	# 	print(count_trailing_zeros(i))

	# masks = generate_masks(new_addresses)

	# for i in masks:
	# 	print(bin(i))	

	sec_mask_list = []

	for i in new_addresses:
		sec_mask_list.append([hex(int(i)), count_trailing_zeros(i)])

	write_lists_to_file("/home/osboxes/Desktop/conattest/ardupilot/sec_mask_result.txt", sec_mask_list)



if __name__ == "__main__":
	cal_section_start_addr()