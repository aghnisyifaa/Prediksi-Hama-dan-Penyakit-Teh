% Menentukan path folder gambar
folder_path = '/MATLAB Drive/SKRIPSI/DATASET/COBA';

% Mendapatkan daftar file gambar dalam folder
file_list = dir(fullfile(folder_path, '*.png'));

% Inisialisasi array untuk fitur GLCM dan label
contrast = [];
correlation = [];
energy = [];
homogeneity = [];
img_labels = [];

% Loop untuk membaca setiap citra dan menghitung GLCM dan fitur-fiturnya
for i = 1:length(file_list)

    % Membaca citra
    img = imread(fullfile(folder_path, file_list(i).name));
    
    % Resize citra menjadi 200x200
    img = imresize(img, [200 200]);

    % Mendeklarasikan empat sudut matriks GLCM yaitu 0°, 45°, 90° dan 135° 
    offsets = [0 1; -1 1; -1 0; -1 -1];

    % Mengubah citra menjadi grayscale dan membuat matriks GLCM
    glcms = graycomatrix(rgb2gray(img), 'Offset', offsets, 'Symmetric', true);
        
    % Menghitung fitur statistik dari matriks GLCM
    stats = graycoprops(glcms);
    
    % Menambahkan fitur-fitur statistik ke dalam array untuk masing-masing gambar
    contrast{i} = stats.Contrast;
    correlation{i} = stats.Correlation;
    energy{i} = stats.Energy;
    homogeneity{i} = stats.Homogeneity;
    
end

% Menghitung rata-rata fitur dari array fitur untuk setiap gambar
avg_contrast = cellfun(@mean, contrast)';
avg_correlation = cellfun(@mean, correlation)';
avg_energy = cellfun(@mean, energy)';
avg_homogeneity = cellfun(@mean, homogeneity)';

% Menyimpan nilai-nilai fitur GLCM ke dalam sebuah tabel
file_names = {file_list.name}';
glcm_table = table(file_names, contrast', correlation', energy', homogeneity',...
    'VariableNames', {'Nama_File', 'Contrast', 'Correlation', 'Energy', 'Homogeneity'});

% Menambahkan rata-rata fitur ke dalam tabel
glcm_table.Avg_Contrast = avg_contrast;
glcm_table.Avg_Correlation = avg_correlation;
glcm_table.Avg_Energy = avg_energy;
glcm_table.Avg_Homogeneity = avg_homogeneity;

% Menampilkan tabel
disp(glcm_table);

% Mengkonversi tabel menjadi format .xlsx
writetable(glcm_table, 'GLCM_MATLAB_BB.xlsx');

