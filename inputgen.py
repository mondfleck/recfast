import os

def generate_file(
    directory="output_files",
    filename="file",
    content_template="This is file {index}"
):
    """
    Generates a set of files with specified parameters.

    Parameters:
        directory (str): The directory to save files in.
        num_files (int): Number of files to generate.
        prefix (str): Prefix for the file names.
        extension (str): File extension (e.g., '.txt').
        content_template (str): Content format for each file. Use {index} for file number.
    """
    
    filepath = os.path.join(directory, filename)
    
    with open(filepath, "x") as f:
        content = content_template
        f.write(content)

# Example usage
if __name__ == "__main__":
    num = 10
    values = [0.9, 1.1]
    files = range(num)
    for file in files:
        for value in values:
            defaults = ["1.0"] * num
            fudges = defaults
            fudges[file] = str(value)
            generate_file(
                directory=".",
                filename=f"f{file}_{value}.int",
                content_template=
                    f"f{file}_{value}.out\n"+
                    "0.04 0.20 0.76\n"+
                    "70 2.725 0.25\n"+
                    "1\n"+
                    "6\n"+
                    " ".join(fudges)
            )