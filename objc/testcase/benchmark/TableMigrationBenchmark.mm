/*
 * Tencent is pleased to support the open source community by making
 * WCDB available.
 *
 * Copyright (C) 2017 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "BaselineBenchmark.h"

@interface TableMigrationBenchmark : BaselineBenchmark

@end

@implementation TableMigrationBenchmark

- (void)doSetUpDatabase
{
    NSString* sourceTable = self.tableName;
    self.tableName = [NSString stringWithFormat:@"t_%@", self.random.string];

    [self.database filterMigration:^(WCTMigrationUserInfo* info) {
        if ([info.table isEqualToString:self.tableName]) {
            info.sourceTable = sourceTable;
        }
    }];

    TestCaseAssertTrue([self.database createTableAndIndexes:self.tableName withClass:BenchmarkObject.class]);

    BOOL done;
    TestCaseAssertTrue([self.database stepMigration:YES done:done]);
    TestCaseAssertFalse(done);
}

- (void)test_read
{
    [self doTestRead];
}

- (void)test_write
{
    [self doTestWrite];
}

- (void)test_batch_write
{
    [self doTestBatchWrite];
}

@end
