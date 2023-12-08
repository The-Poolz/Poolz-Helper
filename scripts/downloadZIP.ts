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
      // Extract the contents to the specified path
      zip.extractAllTo(extractPath, /*overwrite*/ true);

      // Get the name of the extracted folder (e.g., "LockDealNFT-master")
      const extractedFolderName = zip.getEntries()[0].entryName.split('/')[0];

      // Remove all words that start with a hyphen from the extracted folder name
      const modifiedFolderName = extractedFolderName.replace(/-[^/]+/g, '');

      fs.renameSync(`${extractPath}${extractedFolderName}`, `${extractPath}${modifiedFolderName}`);

      fs.unlinkSync(zipPath);
      resolve();
    });
    writer.on('error', reject);
  });
}

export { downloadAndExtractZip };
