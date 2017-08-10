//
//  ViewController.m
//  ZebpayTest
//
//  Created by vatsal raval on 10/08/2017.
//  Copyright © 2017 vatsal raval. All rights reserved.
//

#import "ViewController.h"
#import "SharedClass/SharedClass.h"
#import "MVC/Model/Music.h"
#import "AppDelegate.h"
#import "MVC/View/ArtistNameCollectionViewCell.h"
#import "ArtistImgCollectionViewCell.h"
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>
#import "GenereNameCollectionViewCell.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ViewController ()
{
    __weak IBOutlet UICollectionView *musicCollectionView;
    NSMutableArray<Music*> *musicARray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    musicARray = [[NSMutableArray alloc] init];
    
    if([[SharedClass sharedInstance]connected]){
        [self getMusicDataFromAPI];
    }
    else{
        [self showAlertController];
    }
}

-(void)getMusicDataFromAPI{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[SharedClass sharedInstance] getNewMusicArray:^(id _Nullable responseObject, NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self getDataFromCoreData];
        NSMutableArray *artistIdArray = [NSMutableArray new];
        artistIdArray = [musicARray valueForKey:@"artistId"];
        for(NSMutableDictionary* responseDict in responseObject) {
            
            AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *moc = ad.managedObjectContext;
            if(![artistIdArray containsObject:responseDict[@"artistId"]]){
                Music *newMusic = (Music *)[NSEntityDescription insertNewObjectForEntityForName:@"Music" inManagedObjectContext:moc];
                newMusic.artistId = responseDict[@"artistId"];
                newMusic.artistName = responseDict[@"artistName"];
                newMusic.artistURL = responseDict[@"artistUrl"];
                newMusic.artworkUrl100 = responseDict[@"artworkUrl100"];
                NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:responseDict[@"genreNames"]];
                [newMusic setValue:arrayData forKey:@"genreNames"];
                
                NSError *error = nil;
                // Save the object to persistent store
                if (![moc save:&error]) {
                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }
            }
            else{
                continue;
            }
            
        }
        [self getDataFromCoreData];
        [musicCollectionView reloadData];
        
    }];
}

-(void)getDataFromCoreData{
    NSManagedObjectContext *moc = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Music" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    
    musicARray = [[moc executeFetchRequest:request error:&error] mutableCopy];
    if (!musicARray) {
        // This is a serious error
        // Handle accordingly
        NSLog(@"Failed to load colors from disk");
    }    
}

#pragma mark UICollectionView Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return musicARray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        ArtistImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArtistImgCollectionViewCellIdentifier" forIndexPath:indexPath];
        [cell.artistImgView sd_setImageWithURL:[NSURL URLWithString:musicARray[indexPath.row].artworkUrl100]];
        return cell;
    }
    else if(indexPath.section == 1){
        ArtistNameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ArtistNameCollectionViewCellIdentifier" forIndexPath:indexPath];
        cell.artistNameLbl.text = musicARray[indexPath.row].artistName;
        return cell;
    }
    else{
        GenereNameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GenereNameCollectionViewCellIdentifier" forIndexPath:indexPath];
        NSMutableArray *genereArray = [NSKeyedUnarchiver unarchiveObjectWithData:[musicARray[indexPath.row] valueForKey:@"genreNames"]];
        cell.genereNameLbl.text = [NSString stringWithFormat:@"%@",[[genereArray componentsJoinedByString:@","] stringByReplacingOccurrencesOfString:@"," withString:@"\n"]];
        return cell;
    }
}

#pragma mark - UICOllectionView FlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = 0.0;
    cellWidth = (screenWidth-20)/ indexPath.section+1;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
}

#pragma mark Show Alert
-(void)showAlertController{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"ZebPayTest"
                                                                        message:@"No Internet Connection"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"Ok"
                                                          style:UIAlertActionStyleDestructive
                                                        handler:nil];
    [controller addAction:alertAction];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
