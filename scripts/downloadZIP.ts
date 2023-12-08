import AdmZip from 'adm-zip';
import axios from 'axios';
import fs from 'fs';

async function downloadAndExtractZip(url: string, extractPath: string): Promise<void> {
  if (!fs.existsSync(extractPath)) {
    fs.mkdirSync(extractPath, { recursive: true });
  }

  const response = await axios({
    url,
    method: 'GET',
    responseType: 'stream',
  });

  const zipPath = './temp.zip';
  const writer = fs.createWriteStream(zipPath);

  response.data.pipe(writer);

  return new Promise((resolve, reject) => {
    writer.on('finish', () => {
      const zip = new AdmZip(zipPath);

      // Validate the size of the extracted content
      const entries = zip.getEntries();
      const totalSize = entries.reduce((size, entry) => size + entry.header.size, 0);

      // Set a threshold for the total size (adjust as needed)
      const MAX_TOTAL_SIZE = 1000000000; // 1 GB

      if (totalSize > MAX_TOTAL_SIZE) {
        fs.unlinkSync(zipPath);
        reject('Exceeded max total size');
        return;
      }

      // Extract the contents to the specified path
      zip.extractAllTo(extractPath, /*overwrite*/ true);

      // Get the name of the extracted folder
      const extractedFolderName = entries[0].entryName.split('/')[0];

      // Remove all words that start with a hyphen from the extracted folder name
      const modifiedFolderName = extractedFolderName.replace(/-[^/]+/g, '');

      fs.renameSync(`${extractPath}${extractedFolderName}`, `${extractPath}${modifiedFolderName}`);

      fs.unlinkSync(zipPath);
      resolve();
    });

    writer.on('error', err => {
      fs.unlinkSync(zipPath);
      reject(err);
    });
  });
}

export { downloadAndExtractZip };
