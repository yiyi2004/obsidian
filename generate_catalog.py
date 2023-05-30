import os

def get_files_and_folders(folder_path):
    files = []
    folders = []

    for item in os.listdir(folder_path):
        item_path = os.path.join(folder_path, item)
        if os.path.isfile(item_path):
            files.append(item)
        elif os.path.isdir(item_path):
            folders.append(item)

    return files, folders


if __name__ == "__main__":
    files, paths = get_files_and_folders('.')
    for path in paths:
        if path == '.git':
            continue
        # addings = []
        title = f'{path} index.md'
        index_file = open(os.path.join(path,title), 'w', encoding='utf-8')
        for root, dirs, files in os.walk(path):
            if root.find('Snipaste')!=-1:
                continue
            for file_name in files:
                if file_name == 'index.md':
                    os.remove(os.path.join(root, file_name))
                if file_name == title:
                    continue
                file_path = os.path.join(root, file_name)
                file_real_name = file_name.rsplit('.',1)[0]
                file_path = file_path.split('\\', 1)[-1]
                adding  = f'- [[{file_path}|{file_real_name}]]\n'
                index_file.write(adding.replace('\\', '/'))