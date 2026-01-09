import { createElement } from 'lwc';
import AssetsByTag from 'c/assetsByTag';
import returnTagsWithAssetsByAccount from '@salesforce/apex/AssetsByTagController.returnTagsWithAssetsByAccount';

const RETURNED_TAGS_WITH_ASSETS = require('./data/returnedTagsWithAssets.json')
const FLATTENED_ASSETS = require('./data/flattenedAssets.json');
const TREE_GRID_ASSETS = require('./data/treeGridAssets.json');

jest.mock(
    '@salesforce/apex/AssetsByTagController.returnTagsWithAssetsByAccount',
    () => {
        return {
            default: jest.fn(),
        };
    },
    { virtual: true }
)

describe('c-assets-by-tag', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
    });

    it('it should flatten asset data', () => {
        const element = createElement('c-assets-by-tag', { is: AssetsByTag });
        document.body.appendChild(element);

        const result = element.tagFlattener(RETURNED_TAGS_WITH_ASSETS);

        expect(result).toStrictEqual(FLATTENED_ASSETS);
    });

    it('it should format flattened assets for a tree grid', () => {
        const element = createElement('c-assets-by-tag', { is: AssetsByTag });
        document.body.appendChild(element);

        const result = element.treeGridFormatter(FLATTENED_ASSETS);

        expect(result).toStrictEqual(TREE_GRID_ASSETS);
    });

    it('it should return, flatten, and format our returned assets by account', async () => {
        const element = createElement('c-assets-by-tag', { is: AssetsByTag });
        document.body.appendChild(element);

        returnTagsWithAssetsByAccount.mockResolvedValue(RETURNED_TAGS_WITH_ASSETS);

        const result = await element.getTagsWithAssets();
        expect(result).toStrictEqual(TREE_GRID_ASSETS);
        
        const treeGrid = element.shadowRoot.querySelector('lightning-tree-grid');
        expect(treeGrid.data).toStrictEqual(TREE_GRID_ASSETS);
    })
});