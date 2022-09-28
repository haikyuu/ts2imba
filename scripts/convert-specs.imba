import fs from 'fs'
import np from 'path'
import convert from './utils/convert'
import glob from 'glob'

def convert-all
	glob np.join(__dirname, '../src/tests/specs/*/'), do(err, folders)
		for folder in folders
			glob "{folder}*.txt", do(folderError, files)
				for file in files
					const content = fs.readFileSync(file).toString('utf-8')
					const name = file.split('/')[-1].replace('.txt', '')
					const code = convert content, name
					
					return unless code
					# fs.unlinkSync(file.replace('.txt', '.imba'))
					fs.writeFileSync(file.replace('.txt', '.test.imba'), code)

convert-all!
	
