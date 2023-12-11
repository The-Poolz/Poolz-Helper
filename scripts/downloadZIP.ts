import AdmZip from 'adm-zip';
import * as fs from "fs"
import axios from "axios"

export async function downloadAndExtractZip(url: string, extractPath: string): Promise<void> {
  if (!fs.existsSync(extractPath)) {
    fs.mkdirSync(extractPath, { recursive: true });
  }

  const response = await axios({
    url,
    method: 'GET',
    responseType: 'arraybuffer', // Use 'arraybuffer' to handle binary data
  });

  const zipPath = './temp.zip';
  fs.writeFileSync(zipPath, response.data);

  const zip = new AdmZip(zipPath);

  zip.getEntries().forEach(entry => {
    const entryName = entry.entryName;
    const entryPath = `${extractPath}/${entryName}`;

    // Check if the entry is a directory
    if (entry.isDirectory) {
      // Create the directory if it doesn't exist
      if (!fs.existsSync(entryPath)) {
        fs.mkdirSync(entryPath, { recursive: true });
      }
    } else {
      // Extract the file
      fs.writeFileSync(entryPath, entry.getData());
    }
  });

  // Get the name of the extracted folder (e.g., "LockDealNFT-master")
  const extractedFolderName = zip.getEntries()[0].entryName.split('/')[0];

  // Remove all words that start with a hyphen from the extracted folder name
  const modifiedFolderName = extractedFolderName.replace(/-[^/]+/g, '');

  // Rename the extracted folder
  fs.renameSync(`${extractPath}/${extractedFolderName}`, `${extractPath}/${modifiedFolderName}`);

  // Clean up
  fs.unlinkSync(zipPath);
}