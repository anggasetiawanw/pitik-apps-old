/**
 *@author Robertus Mahardhi Kuncoro
 *@email <robert.kuncoro@pitik.id>
 *@create date 31/07/23
 */

class Table {
    final String tableName;
    final int whenExists;

    const Table(this.tableName, [this.whenExists = 1]);
}