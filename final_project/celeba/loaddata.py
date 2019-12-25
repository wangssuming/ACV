# -*- coding: utf-8 -*-
"""
Created on Thu May 23 18:05:05 2019

@author: hb2506
"""
import numpy as np
from torchvision import transforms
from torch.utils import data
from PIL import Image


class Dataset(data.Dataset):
    'Characterizes a dataset for PyTorch'
    def __init__(self, test, root):
        'Initialization'
        list_IDs = []
        labels = []
        self.test = test
        self.root = root
        self.transform = transforms.Compose([transforms.RandomHorizontalFlip(p=0.5),
                                             transforms.ToTensor(),
                                             transforms.Normalize((0.5, 0.5, 0.5),(0.5, 0.5, 0.5))
                                             ])
        if self.test:
            batch_siz = 700
            hair = np.random.randint(0, 4, batch_siz)
            wair = np.random.randint(4, 6, batch_siz)
            other = np.random.randint(0, 2, (batch_siz, 34))
            
            gen_labels = np.zeros((batch_siz,6))
            gen_labels[np.arange(batch_siz), hair] = 1
            gen_labels[np.arange(batch_siz), wair] = 1
            gen_labels = np.concatenate((gen_labels, other), axis=1)
        
            
            with open('./test_images_fid/' + 'celebA2.txt', 'w') as f:
                for line in gen_labels:
                    s = [str(i) for i in line]  
                    res = " ".join(s)
                    f.writelines(res+'\n')
            self.labels = gen_labels.astype(int)
        else:
            with open(self.root + 'label.txt', encoding="utf-8") as f:
                lines = f.readlines()
            lines = lines[1:]
            for i, line in enumerate(lines):
                list_IDs.append(line.split('.jpg')[0]+'.jpg')
#                print(list_IDs)
                labels.append(line.rstrip('\n').split('jpg\t')[1].split('\t'))
            self.labels = np.array(labels).astype(int)
            self.list_IDs = list_IDs
#            print(self.list_IDs[0])

    def __len__(self):
        'Denotes the total number of samples'
        return self.labels.shape[0]

    def __getitem__(self, index):
        'Generates one sample of data'
        if self.test:
            label = self.labels[index]
            return label
        else:
            # Select sample
            ID = self.list_IDs[index]
    
            # Load data and get label
#            print(ID)
            img = Image.open(self.root + 'img_align_celeba/' + ID)
            img = img.resize((128, 128))
            img = self.transform(img)
            label = self.labels[index]
    
            return img, label