import os
from os.path import join, isdir
import shutil
from shutil import rmtree as remove_dir
import multiprocessing

# current working directory (should be /.../doodles)
cwd = os.getcwd()

excluded = [".export", ".git"]


def main():
    count = 0

    files = []
    for dirpath, dirnames, filenames in os.walk(os.getcwd()):
        if any((dirpath.find(s)>-1 for s in excluded)):
            continue
        files.extend([(dirpath, f) for f in filenames])

    with multiprocessing.Pool(4) as p:
        p.map(process_file, files)

    for fn in filenames:
        res = count_file(dirpath, fn)
        if res:
            count += 1

    print(f"\n{count} and counting.\n")


def process_file(*args):
    dirpath, filename = args[0]

    if not is_pico8(filename) or is_wip(filename):
        print("......" + filename)
        return

    # pure name, no extension
    name = (filename)[:-3]

    # full path of file
    filepath = join(dirpath, filename)

    rel_dir = get_rel_dir(filepath)

    final_export_dir = join(cwd, ".export\\", rel_dir[1:])
    if not isdir(final_export_dir):
        os.makedirs(final_export_dir)

    # execute shell script to export
    # this is not placed in final location!
    shell_export_html(filepath, name)
    initial_export_dir = join(cwd, f"{name}_html")

    exported_html_dir = join(final_export_dir, f"{name}_html")
    if isdir(exported_html_dir):
        remove_dir(exported_html_dir)

    try:
        shutil.move(initial_export_dir, final_export_dir)
    except Exception:
        pass  # lazy, b/c i don't care if it goes wrong

    print(f"-> {filename}")


def get_rel_dir(filepath):
    rel_dir = filepath
    i = rel_dir.find("doodles") + 7
    rel_dir = rel_dir[i:-3]  # remove ".p8"
    return rel_dir


def shell_export_html(filepath, name):
    return os.system(f'''pico8 {filepath} -export "-f {name}.html"''')


def archive_dir_in_place(dirpath):
    # join(cwd, ".export\\", newdir[1:], f"{exportname}_html")
    shutil.make_archive(dirpath, "zip", dirpath)
    shutil.remove_dir(dirpath)


def count_file(*args):
    dirpath, filename = args
    return is_pico8(filename) and not is_wip(filename)


def is_pico8(filename):
    return filename.endswith(".p8")


def is_wip(filename):
    return filename.startswith("_")


if __name__ == "__main__":
    main()
